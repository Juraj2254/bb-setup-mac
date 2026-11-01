#!/usr/bin/env bash
# Install the bb desktop app (Apple Silicon), open it, and put the `bb` command on PATH.
# Safe to run again: it skips what is already there.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$HERE/env.sh"

[ "$(uname -s)" = Darwin ] || { echo "✘ Ova skripta je za Mac." >&2; exit 2; }
if [ "$(uname -m)" != arm64 ]; then
  echo "✘ bb aplikacija radi na Macovima s Apple čipom (M1 i noviji)."
  echo "  Na Intel Macu pokreni bb ovako: npm install -g bb-app && bb-app start"
  exit 3
fi

APP=""
for d in /Applications "$HOME/Applications"; do
  [ -d "$d/bb.app" ] && APP="$d/bb.app"
done

if [ -z "$APP" ]; then
  echo "==> Preuzimam bb za macOS"
  URL="$(curl -fsSL https://api.github.com/repos/get-bb/bb/releases/tags/desktop-latest | python3 -c '
import json, sys
assets = json.load(sys.stdin)["assets"]
print(next(a["browser_download_url"] for a in assets if a["name"].endswith("-arm64.zip")))')"
  TMP="$(mktemp -d)"
  curl -fL --progress-bar -o "$TMP/bb.zip" "$URL"
  DEST=/Applications
  [ -w "$DEST" ] || DEST="$HOME/Applications"
  mkdir -p "$DEST"
  ditto -x -k "$TMP/bb.zip" "$DEST"
  rm -rf "$TMP"
  APP="$DEST/bb.app"
  echo "✔ bb instaliran: $APP"
else
  echo "✔ bb je već instaliran: $APP"
fi

echo "==> Otvaram bb"
open "$APP"

# The bb CLI talks to the running app. Use the app's own launcher when it exists,
# otherwise the one from npm (needs Node.js, see install-node.sh).
bbcli() {
  if command -v bb >/dev/null 2>&1; then bb "$@"
  elif [ -x "$HOME/.bb/bin/bb" ]; then "$HOME/.bb/bin/bb" "$@"
  else npx --yes --package bb-app bb "$@"
  fi
}

printf '==> Čekam da bb krene'
ready=0
for _ in $(seq 1 60); do
  if bbcli status >/dev/null 2>&1; then ready=1; break; fi
  printf '.'; sleep 3
done
echo
if [ "$ready" != 1 ]; then
  echo "✘ bb se nije javio u 3 minute. Provjeri je li prozor bb otvoren, pa pokreni skriptu ponovno."
  exit 1
fi
echo "✔ bb radi"

if command -v bb >/dev/null 2>&1; then
  echo "✔ bb naredba je već na PATH-u ($(command -v bb))"
else
  echo "==> Instaliram bb naredbu (Settings → General → Command line)"
  bbcli settings cli-command install || true
  . "$HERE/env.sh"
  if command -v bb >/dev/null 2>&1; then
    echo "✔ bb naredba: $(command -v bb)"
  else
    echo "! bb naredba nije na PATH-u. U bb-u: Settings → General → Command line → Install, pa otvori novi Terminal."
    exit 1
  fi
fi
echo
echo "U prozoru bb klikni kroz uvod (Continue ili Skip setup)."
