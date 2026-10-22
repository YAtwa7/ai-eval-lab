#!/usr/bin/env python3
"""Live credential verification for ai-eval-lab. Never prints a secret.

Uses httpx rather than urllib: httpx honours the certifi trust store
(macOS python.org builds do not wire that into urllib), and httpx is what
the harness itself will use, so this verifies the real path rather than a
parallel one.

Run from the repo root:  .venv/bin/python verify.py
Exit 0 = every configured provider answered a live call.
"""

import os
import sys
import time

import httpx

ENV = os.path.join(os.path.dirname(os.path.abspath(__file__)), ".env.local")
TIMEOUT = 45


def load_env():
    env = {}
    for raw in open(ENV, encoding="utf-8"):
        line = raw.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        k, _, v = line.partition("=")
        env[k.strip()] = v.strip().strip('"').strip("'")
    return env


def main():
    if not os.path.exists(ENV):
        print(f"error: {ENV} not found - run: cp .env.example .env.local")
        return 1

    env = load_env()
    results = {}

    with httpx.Client(timeout=TIMEOUT) as client:
        # ---- Gemini -------------------------------------------------------
        print("== Gemini: live generateContent ==")
        gkey = env.get("GEMINI_API_KEY", "")
        model = env.get("GEMINI_MODEL", "gemini-3.8-flash")
        if not gkey:
            print("  SKIPPED - no key")
            results["gemini"] = "SKIP"
        else:
            print(f"  model: {model}")
            # Gemini's free tier is capacity-limited and returns 503
            # "high demand" under load. That is a transient condition, not a
            # credential problem - so retry, and fall back to the alias.
            candidates = [model]
            if "latest" not in model:
                candidates.append("gemini-flash-latest")
            last = None
            for cand in candidates:
                for attempt in range(1, 5):
                    try:
                        r = client.post(
                            "https://generativelanguage.googleapis.com/v1beta/models/"
                            f"{cand}:generateContent",
                            headers={"x-goog-api-key": gkey},
                            json={
                                "contents": [
                                    {"parts": [{"text": "Reply with exactly: PONG"}]}
                                ]
                            },
                        )
                    except Exception as e:  # noqa: BLE001
                        print(f"  {cand} attempt {attempt}: {type(e).__name__}")
                        last = (cand, 0, str(e)[:120])
                        time.sleep(2 * attempt)
                        continue
                    if r.status_code == 200:
                        d = r.json()
                        text = d["candidates"][0]["content"]["parts"][0].get("text", "")
                        u = d.get("usageMetadata", {})
                        print(f"  HTTP 200 via {cand} (attempt {attempt})")
                        print(f"  reply: {text!r}")
                        print(f"  tokens: in={u.get('promptTokenCount')} out={u.get('candidatesTokenCount')}")
                        results["gemini"] = "OK"
                        last = None
                        break
                    msg = r.json().get("error", {}).get("message", r.text[:120])
                    print(f"  {cand} attempt {attempt}: HTTP {r.status_code} {msg[:80]}")
                    last = (cand, r.status_code, msg)
                    if r.status_code not in (429, 503, 500):
                        break
                    time.sleep(2 * attempt)
                if results.get("gemini") == "OK":
                    break
            if results.get("gemini") != "OK":
                results["gemini"] = f"FAIL {last[1] if last else '?'}"

        # ---- LangSmith ----------------------------------------------------
        print("\n== LangSmith: region + live read + live write ==")
        lskey = env.get("LANGSMITH_API_KEY", "")
        url = env.get("LANGSMITH_API_URL", "https://api.smith.langchain.com")
        if not lskey:
            print("  SKIPPED - no key")
            results["langsmith"] = "SKIP"
        else:
            print(f"  region host: {url}")
            try:
                r = client.get(f"{url}/api/v1/datasets?limit=1", headers={"x-api-key": lskey})
                print(f"  GET /datasets -> HTTP {r.status_code}")
                results["langsmith_read"] = "OK" if r.status_code == 200 else f"FAIL {r.status_code}"
            except Exception as e:  # noqa: BLE001
                print(f"  GET /datasets -> {type(e).__name__}: {str(e)[:120]}")
                results["langsmith_read"] = "FAIL"

            try:
                from langsmith import Client

                c = Client(api_key=lskey, api_url=url)
                d = c.create_dataset(
                    dataset_name=f"setup-check-{int(time.time())}",
                    description="credential verification",
                )
                print(f"  create_dataset -> OK ({d.name})")
                results["langsmith_write"] = "OK"
            except Exception as e:  # noqa: BLE001
                print(f"  create_dataset -> {type(e).__name__}: {str(e)[:160]}")
                results["langsmith_write"] = "FAIL"

    print("\n== summary ==")
    for k, v in results.items():
        print(f"  {k:<18} {v}")
    hard = [v for v in results.values() if v not in ("OK", "SKIP")]
    return 1 if hard else 0


if __name__ == "__main__":
    sys.exit(main())
