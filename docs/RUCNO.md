# Ručna instalacija na Macu (bez agenta)

Isti koraci koje inače odradi agent. Svaku naredbu zalijepi u Terminal (**Cmd + V**) i pritisni Enter.
Skripte se smiju pokretati više puta: preskoče ono što je već gotovo.

## 1. Mapa i Command Line Tools

```sh
cd ~/Downloads/bb-setup-mac-main
xcode-select --install
```

U prozoru klikni **Install** i pričekaj kraj (ako kaže da su već instalirani, idi dalje).

## 2. Node.js i agenti (VPN uključen)

```sh
bash scripts/install-node.sh
bash scripts/install-agents.sh
```

Zatvori Terminal (**Cmd + Q**), otvori ga ponovno i vrati se u mapu:

```sh
cd ~/Downloads/bb-setup-mac-main
```

## 3. Prijave

```sh
claude
```

Na prvim pitanjima pritisni Enter, izaberi **Claude account with subscription**, u pregledniku klikni
**Authorize**, pa upiši `/exit`.

```sh
codex login
croz-code setup
```

Za `croz-code setup` zalijepi Jarvis API ključ (https://jarvis.croz.net/onboarder).

## 4. Most, bb i harness

```sh
bash scripts/bb-pi-most.sh
bash scripts/install-bb-mac.sh
```

U prozoru bb klikni **Continue** dok Codex, Claude Code i Pi pišu **Ready**, a ostalo **Skip**. Zatim:

```sh
bash scripts/bb-harness.sh
```

Na pitanje `Nastaviti? [D/n]` pritisni Enter.

## 5. Provjera

```sh
bash scripts/check.sh
```

Sve linije trebaju imati ✔. U bb-u: **Settings → Installed plugins → Memory** (memorije), a u novom threadu
izaberi **Pi** i pitaj `Što znaš o meni i mojim projektima?`.

## Što koja skripta radi

| Skripta | Što radi |
|---|---|
| `check.sh` | samo čita i ispiše stanje svakog koraka |
| `install-node.sh` | nvm i Node.js 24, bez sudo |
| `install-agents.sh` | Claude Code, Codex, CROZ Code (s CROZ Nexusa) |
| `bb-pi-most.sh` | `~/.local/bin/pi`: bb-ov agent Pi pokreće CROZ Code |
| `install-bb-mac.sh` | bb aplikacija u Applications i `bb` naredba |
| `bb-harness.sh` | Memory plugin, zajednička pravila, skillovi u `~/.bb/skills`, Jarvis ključ za croz-tools, uvoz starog konteksta |
| `bb-skills.py` | kopira skillove iz `~/.claude`, `~/.codex`, `~/.agents` i CROZ Codea u bb (originale ne dira) |
| `bb-kontekst.py` | skuplja stari kontekst (samo čita, tajne zamaskira) |

Opcije harnessa: `--dry-run` (samo pokaže plan), `--no-import`, `--no-skills`, `--link-skills` (poveže bb
skillove natrag u `~/.claude/skills` i `~/.agents/skills`), `--keep-croz-memory`, `--max-projects N`,
`--provider claude-code|codex|pi`.
