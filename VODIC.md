# bb na Macu: kompletan vodič korak po korak

Ovaj vodič te vodi kroz cijelu instalaciju, od praznog Maca do bb-a s tri agenta, zajedničkom memorijom,
svim skillovima i uvezenim starim kontekstom. Idi redom i kvačicom označi svaki korak kad prođe njegova
provjera.

**Kako čitati vodič**

- **Terminal**: kopiraj cijeli sivi blok (na GitHubu gumb za kopiranje u gornjem desnom kutu bloka),
  zalijepi ga u Terminal s **Cmd + V** i pritisni Enter.
- **Klik**: radiš mišem, izvan Terminala.
- **Provjera**: naredba i što mora pisati. Ne idi dalje dok provjera ne prođe.
- Sve naredbe smiješ pokrenuti ponovno. Ako je nešto već napravljeno, preskoče ga.
- CROZ VPN drži uključen od koraka 7 do kraja.

**Sadržaj**

- [A. Prije početka](#a-prije-početka)
- [B. Brzi put: sve odradi agent](#b-brzi-put-sve-odradi-agent)
- [C. Ručni put, korak po korak](#c-ručni-put-korak-po-korak)
- [D. Završna provjera](#d-završna-provjera)
- [E. Testovi u bb-u](#e-testovi-u-bb-u)
- [F. Svaki dan](#f-svaki-dan)
- [G. Kasnije: novi skillovi i projekti](#g-kasnije-novi-skillovi-i-projekti)
- [H. Ako nešto ne radi](#h-ako-nešto-ne-radi)
- [I. Što je gdje](#i-što-je-gdje)

---

## A. Prije početka

### A1. Računi i ključevi

- [ ] **Claude pretplata** (Pro ili Max). Provjera: na https://claude.ai si prijavljen i vidiš svoj plan.
- [ ] **ChatGPT pretplata** (Plus ili Pro). Provjera: na https://chatgpt.com si prijavljen.
- [ ] **Jarvis API ključ**: https://jarvis.croz.net/onboarder (stranica radi samo na CROZ mreži ili VPN-u).
      Ključ drži pri ruci, trebat će u koraku 7.
- [ ] **CROZ VPN** radi (spoji se jednom za probu).

### A2. Mac

- [ ] Mac ima Apple čip (M1 ili noviji). **Klik**: Apple izbornik  → **About This Mac** → piše **Chip: Apple M…**.
      Na Intel Macu bb aplikacija ne radi; vidi [H. Intel Mac](#intel-mac).
- [ ] macOS 13 ili noviji (isti prozor, red **macOS**).
- [ ] Imaš administratorski račun na Macu (inače instalacija u Applications ne prolazi).

### A3. Pristup repozitoriju (repo je privatan)

Ako instaliraš na tuđem Macu, prvo daj pristup toj osobi:

- [ ] **Klik**: https://github.com/Juraj2254/bb-setup-mac → **Settings** → **Collaborators** → **Add people** →
      upiši GitHub korisničko ime → **Add**. Osoba prihvati pozivnicu iz e-maila.

Druga mogućnost: ti preuzmeš ZIP (korak 3) i pošalješ ga (Teams, e-mail).

---

## B. Brzi put: sve odradi agent

Ako želiš da instalaciju vodi agent, napravi samo ovo, a zatim idi na [D. Završna provjera](#d-završna-provjera).

1. [ ] Napravi korake [C1](#c1-otvori-terminal), [C2](#c2-command-line-tools-git-i-python) i [C3](#c3-preuzmi-repozitorij).
2. [ ] **Terminal** (agent je Codex):

   ```sh
   bash ~/Downloads/bb-setup-mac-main/bootstrap.sh
   ```

   Ako želiš da vodi Jarvis (CROZ Code, VPN mora biti uključen):

   ```sh
   bash ~/Downloads/bb-setup-mac-main/bootstrap.sh jarvis
   ```

3. [ ] U pregledniku se prijavi u ChatGPT (ili upiši Jarvis ključ). Ako Codex pita vjeruješ li mapi, pritisni Enter.
4. [ ] Razgovaraj s agentom na hrvatskom. Kad traži prijavu ili klik, učini to i napiši `gotovo`.
5. [ ] Na kraju agent mora reći da `check.sh` ima sve ✔. Ipak prođi [D](#d-završna-provjera) i [E](#e-testovi-u-bb-u).

---

## C. Ručni put, korak po korak

### C1. Otvori Terminal

- [ ] **Klik**: pritisni **Cmd + razmak**, upiši `Terminal` i pritisni Enter.

### C2. Command Line Tools (Git i Python)

- [ ] **Terminal**:

  ```sh
  xcode-select --install
  ```

- [ ] **Klik**: u prozoru koji se otvori klikni **Install**, pa **Agree**. Pričekaj kraj (5 do 15 minuta).
      Ako piše da su alati već instalirani, idi dalje.
- [ ] **Provjera**:

  ```sh
  git --version && python3 --version
  ```

  Mora pisati `git version 2.…` i `Python 3.…`.

### C3. Preuzmi repozitorij

- [ ] **Klik**: otvori https://github.com/Juraj2254/bb-setup-mac → zeleni gumb **Code** → **Download ZIP**.
- [ ] **Klik**: ako se zip nije sam otvorio, u Finderu u **Downloads** dvoklikni `bb-setup-mac-main.zip`.
- [ ] **Provjera** (Terminal):

  ```sh
  ls ~/Downloads/bb-setup-mac-main
  ```

  Moraju se vidjeti `AGENTS.md`, `bootstrap.sh`, `scripts`, `prompts`, `docs`.

### C4. Node.js

- [ ] **Terminal**:

  ```sh
  touch ~/.zshrc
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.8/install.sh | bash
  ```

- [ ] **Klik**: zatvori Terminal (**Cmd + Q**) i otvori ga ponovno (C1).
- [ ] **Terminal**:

  ```sh
  nvm install 24
  ```

- [ ] **Provjera**:

  ```sh
  node --version && npm --version
  ```

  Mora pisati `v24.…` i broj verzije npm-a.

### C5. Claude Code

- [ ] **Terminal**:

  ```sh
  curl -fsSL https://claude.ai/install.sh | bash
  grep -q 'bb-setup: local bin' ~/.zshrc || printf '\n# bb-setup: local bin\nexport PATH="$HOME/.local/bin:$PATH"\n' >> ~/.zshrc
  source ~/.zshrc
  claude --version
  ```

  Zadnji red mora ispisati verziju, npr. `2.1.… (Claude Code)`.
- [ ] **Prijava** (Terminal):

  ```sh
  claude
  ```

  1. Na prvim pitanjima (tema, napomene) pritisni Enter.
  2. Izaberi **1. Claude account with subscription** i pritisni Enter.
  3. **Klik**: u pregledniku se prijavi i klikni **Authorize**.
  4. U Terminalu: `Login successful`, pritisni Enter. Ako pita vjeruješ li mapi, izaberi **Yes**.
  5. Upiši `/exit` i pritisni Enter.
- [ ] **Provjera**:

  ```sh
  claude auth status
  ```

  Mora pisati `"loggedIn": true`.

### C6. Codex

- [ ] **Terminal**:

  ```sh
  curl -fsSL https://chatgpt.com/codex/install.sh | sh
  source ~/.zshrc
  codex --version
  ```

- [ ] **Prijava**:

  ```sh
  codex login
  ```

  **Klik**: u pregledniku se prijavi svojim ChatGPT računom i potvrdi.
- [ ] **Provjera**:

  ```sh
  codex login status
  ```

  Mora pisati `Logged in using ChatGPT`.

### C7. CROZ Code (VPN uključen)

- [ ] **Provjera VPN-a**:

  ```sh
  curl -sS -o /dev/null -w '%{http_code}\n' https://nexus.croz.net/repository/npm/
  ```

  Mora pisati `200`. Ako ne piše, uključi CROZ VPN i ponovi.
- [ ] **Terminal**:

  ```sh
  npm install -g @croz/croz-code --registry https://nexus.croz.net/repository/npm/
  croz-code --version
  ```

- [ ] **Jarvis ključ**:

  ```sh
  croz-code setup
  ```

  Kod `Jarvis API key:` zalijepi ključ (Cmd + V) i pritisni Enter. Mora pisati `✔ Saved. You are ready.`
- [ ] **Provjera**:

  ```sh
  croz-code doctor
  ```

  Linije `Jarvis` i `CROZ tools gateway` moraju imati ✔.

### C8. Most Pi → CROZ Code

bb-ov agent **Pi** tako pokreće CROZ Code.

- [ ] **Terminal**:

  ```sh
  cd ~/Downloads/bb-setup-mac-main
  bash scripts/bb-pi-most.sh
  ```

  Mora pisati `✔ Most je spreman: /Users/<ime>/.local/bin/pi (Pi 1.1.0)` (broj može biti drugačiji).

### C9. bb aplikacija

- [ ] Ako je bb već otvoren, zatvori ga (**Cmd + Q**). bb vidi alate samo ako ih zatekne pri pokretanju.
- [ ] **Terminal**:

  ```sh
  cd ~/Downloads/bb-setup-mac-main
  bash scripts/install-bb-mac.sh
  ```

  Skripta preuzme bb, stavi ga u Applications, otvori ga, pričeka da krene i instalira naredbu `bb`.
  Na kraju mora pisati `✔ bb radi` i `✔ bb naredba: …`.
- [ ] **Klik** u prozoru bb (uvod):
  1. **Connect a coding agent**: Codex, Claude Code i Pi moraju pisati **Ready**. Klikni **Continue**.
     Ako neki ne piše Ready: zatvori bb (Cmd + Q), otvori ga iz Applications i provjeri ponovno.
  2. **Add your projects**: klikni **Import** (ili **Skip**; skripta u C10 doda stare projekte).
  3. **Plugins** i **Devices**: **Continue** ili **Skip**.
- [ ] **Provjera** (novi prozor Terminala, **Cmd + N**):

  ```sh
  bb status && bb provider list
  ```

  Na popisu moraju biti `codex`, `claude-code` i `pi`.

Ako skripta ne uspije instalirati naredbu `bb`: **Klik** u bb-u zupčanik dolje lijevo → **Settings** →
**General** → **Command line** → **bb CLI** → **Install**, pa otvori novi prozor Terminala.

### C10. Zajednička memorija, skillovi i stari kontekst

- [ ] **Terminal**, prvo samo plan (ništa ne mijenja):

  ```sh
  cd ~/Downloads/bb-setup-mac-main
  bash scripts/bb-harness.sh --dry-run
  ```

  Pročitaj popis: koji projekti i koliko skillova će ući.
- [ ] **Terminal**, pravo pokretanje:

  ```sh
  bash scripts/bb-harness.sh
  ```

  Na `Nastaviti? [D/n]` pritisni Enter. Skripta prolazi 7 koraka:

  1. most Pi → CROZ Code upisan u bb (`BB_PI_BRIDGE_COMMAND`);
  2. bb Memory plugin uključen;
  3. zasebne memorije Claude Codea, Codexa i CROZ Codea isključene;
  4. zajednička pravila u `~/.bb/AGENTS.md`;
  5. svi skillovi u `~/.bb/skills` i Jarvis ključ u bb-u (za skill croz-tools);
  6. stari kontekst u `~/.bb/legacy-context`;
  7. stari projekti dodani u bb i pokrenuti threadovi **Uvoz konteksta**.

  Na kraju mora pisati `==> Gotovo`.

### C11. Pričekaj uvoz

- [ ] **Klik**: u bb-u lijevo vidiš threadove **Uvoz konteksta · …** (jedan po projektu i jedan **globalno**).
      Svaki traje minutu ili dvije.
- [ ] Kad svi završe: **Settings → Installed plugins → Memory**. Mora biti popis memorija (Scope `global` i
      imena projekata).

---

## D. Završna provjera

- [ ] **Terminal**:

  ```sh
  bash ~/Downloads/bb-setup-mac-main/scripts/check.sh
  ```

  Svaka linija mora imati ✔, a na kraju mora pisati `Sve je spremno.` Uz svaki ✘ piše što napraviti.

- [ ] **Terminal**, varijable u bb-u:

  ```sh
  bb machine env list
  ```

  Moraju postojati `BB_PI_BRIDGE_COMMAND`, `CROZ_MEMORY` i `JARVIS_API_KEY` (vrijednosti su skrivene).

- [ ] **Terminal**, memorija i skillovi:

  ```sh
  bb memory catalog | head -20
  bb skill list --json | python3 -c 'import json,sys; print(sum(1 for s in json.load(sys.stdin)["skills"] if s["scope"]=="bb-user"), "skillova za sve agente")'
  ```

- [ ] **Klik** u bb-u:
  - **Settings → Providers**: Codex, Claude Code i Pi su na popisu.
  - **Settings → Providers → Claude Code**: **Claude Code memory** je isključen.
  - **Settings → Providers → Codex**: **Codex memory** je isključen.
  - **Settings → Installed plugins → Memory**: plugin je uključen i ima memorije.
  - **Settings → Environment variables**: tri varijable iz provjere iznad.

---

## E. Testovi u bb-u

Za svaki test: **New thread** → klikni izbornik modela ispod polja za poruku → izaberi karticu agenta.

- [ ] **Pi (CROZ Code, VPN uključen)**: `Što znaš o meni i mojim projektima?`
      Mora odgovoriti iz zajedničke memorije (tvoj posao, tvoji projekti).
- [ ] **Zajednička memorija**:
  1. U threadu s **Codexom**: `Zapamti globalno: izvještaje želim kao tablicu.`
  2. U novom threadu s **Claude Codeom**: `Kako želim izvještaje?` Mora reći: kao tablicu.
- [ ] **Skill croz-tools u Claude Codeu** (VPN uključen): `Koristi skill croz-tools i pronađi na CROZ Confluenceu stranicu o VPN-u.`
- [ ] **Skillovi**: u polju za poruku upiši `/`. Moraju se pojaviti tvoji skillovi.

---

## F. Svaki dan

- [ ] Otvori aplikaciju **bb** (Launchpad ili Applications).
- [ ] Za agenta **Pi** (CROZ Code) i skill croz-tools uključi CROZ VPN.

bb se ažurira sam: kad stigne nova verzija, **Settings → Updates**.

---

## G. Kasnije: novi skillovi i projekti

- **Dodao si nove skillove** u Claude Code, Codex ili CROZ Code: kopiraj ih u bb bez novog uvoza konteksta.

  ```sh
  bash ~/Downloads/bb-setup-mac-main/scripts/bb-harness.sh --no-import
  ```

- **Novi skill samo za bb**: spremi mapu skilla (s datotekom `SKILL.md`) u `~/.bb/skills/<ime-skilla>/`.
- **Novi projekt**: dodaj mapu u bb (**Settings → Projects**) ili iz Terminala:

  ```sh
  bb project create --name "ime-projekta" --root ~/putanja/do/mape
  ```

  Agenti sami pišu u memoriju dok rade na njemu.
- **Ponovni uvoz starog konteksta** (npr. nakon puno rada izvan bb-a): pokreni `bb-harness.sh` bez opcija.
  Agenti neće upisati duplikate.

---

## H. Ako nešto ne radi

| Problem | Rješenje |
|---|---|
| `command not found` odmah nakon instalacije | Zatvori Terminal (Cmd + Q) i otvori ga ponovno. |
| `nvm: command not found` | `touch ~/.zshrc`, ponovi C4 i otvori novi Terminal. |
| `curl … nexus.croz.net` ne daje `200` | Uključi CROZ VPN. |
| `croz-code doctor`: Jarvis ✘ | VPN; zatim ponovno `croz-code setup` i zalijepi ključ. |
| U uvodu bb-a agent nije **Ready** | Zatvori bb (Cmd + Q), otvori ga ponovno. Provjeri da C5 do C8 prolaze. |
| `bb: command not found` | **Settings → General → Command line → Install**, pa novi Terminal (Cmd + N). |
| Skripta kaže `bb ne odgovara` | Otvori aplikaciju bb i pričekaj pola minute. |
| Thread **Uvoz konteksta** traži odobrenje | Klikni **Allow**. |
| Pi ne radi u bb-u | VPN; zatim `~/.local/bin/pi --version` mora ispisati broj; ponovi C8 i C10. |
| Bilo što drugo | `bash ~/Downloads/bb-setup-mac-main/scripts/check.sh` i napravi ono što piše uz prvi ✘. |

### Intel Mac

bb aplikacija radi samo na Apple čipu. Na Intel Macu umjesto C9 pokreni bb iz Terminala:

```sh
npm install -g bb-app --allow-scripts=better-sqlite3,node-pty,@parcel/watcher
bb-app start
```

Taj prozor ostavi otvoren, a bb otvori u pregledniku na http://localhost:38886. Ostali koraci su isti.

---

## I. Što je gdje

| Što | Gdje |
|---|---|
| bb aplikacija | `/Applications/bb.app` |
| bb podaci, memorija, postavke | `~/.bb/` |
| Zajednička pravila za sve agente | `~/.bb/AGENTS.md` |
| Skillovi koje bb daje svim agentima | `~/.bb/skills/` (popis izvora: `~/.bb/skills/.bb-skills-import.json`) |
| Stari kontekst (sažeci) | `~/.bb/legacy-context/` |
| Most Pi → CROZ Code | `~/.local/bin/pi` |
| Claude Code, Codex | `~/.local/bin/claude`, `~/.local/bin/codex` |
| Node.js | `~/.nvm/` |
| CROZ Code postavke i ključ | `~/.croz-code/agent/` |
| Skripte instalacije | `~/Downloads/bb-setup-mac-main/scripts/` |
