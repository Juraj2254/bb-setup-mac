#!/usr/bin/env bash
# Prvi korak: instalira agenta koji odradi ostatak instalacije prema AGENTS.md.
#
#   bash bootstrap.sh          # instalacijski agent je Codex (ChatGPT pretplata)
#   bash bootstrap.sh jarvis   # instalacijski agent je Jarvis (CROZ Code, treba VPN)
set -euo pipefail
cd "$(dirname "$0")"
. scripts/env.sh
AGENT="${1:-codex}"

touch "$HOME/.zshrc"
grep -q 'bb-setup: local bin' "$HOME/.zshrc" || printf '\n# bb-setup: local bin\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$HOME/.zshrc"

if ! xcode-select -p >/dev/null 2>&1; then
  echo "==> Instaliram Apple Command Line Tools (Git, Python)."
  xcode-select --install || true
  echo
  echo "U prozoru koji se otvorio klikni Install. Kad završi, ponovno pokreni:"
  echo "  bash $PWD/bootstrap.sh $AGENT"
  exit 0
fi

case "$AGENT" in
  codex)
    bash scripts/install-agents.sh codex
    . scripts/env.sh
    if ! codex login status >/dev/null 2>&1; then
      echo "==> Prijava u Codex: otvorit će se preglednik, prijavi se svojim ChatGPT računom."
      codex login
    fi
    echo "==> Pokrećem Codex. On nastavlja instalaciju i vodi te kroz korake."
    exec codex -s danger-full-access -a on-request -C "$PWD" "$(cat prompts/start.md)"
    ;;
  jarvis)
    bash scripts/install-node.sh
    . scripts/env.sh
    bash scripts/install-agents.sh croz
    . scripts/env.sh
    if ! python3 -c 'import json,os,sys; d=json.load(open(os.path.expanduser("~/.croz-code/agent/auth.json"))); sys.exit(0 if d.get("jarvis",{}).get("key") else 1)' 2>/dev/null; then
      echo "==> CROZ Code treba tvoj Jarvis API ključ (https://jarvis.croz.net/onboarder)."
      croz-code setup
    fi
    echo "==> Pokrećem Jarvis (CROZ Code). On nastavlja instalaciju i vodi te kroz korake."
    exec croz-code "$(cat prompts/start.md)"
    ;;
  *)
    echo "Upotreba: bash bootstrap.sh [codex|jarvis]" >&2
    exit 2
    ;;
esac
