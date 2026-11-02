# bb na Macu

**Detaljan vodič korak po korak, s naredbama za kopiranje i provjerama: [VODIC.md](VODIC.md)**

Instalaciju bb-a odradi AI agent (Codex ili Jarvis). Ti samo pokreneš jednu naredbu, prijaviš se gdje te
pita i klikneš što ti kaže.

Na kraju imaš aplikaciju **bb** s tri agenta i jednom zajedničkom memorijom:

| Agent u bb-u | Što pokreće | Na čemu radi |
|---|---|---|
| Claude Code | Claude Code | tvoja Claude pretplata |
| Codex | Codex | tvoja ChatGPT pretplata |
| Pi | CROZ Code | Jarvis, CROZ AI gateway |

- **Zajednička memorija (bb Memory).** Svi agenti čitaju i pišu istu memoriju, globalnu i po projektu.
- **Svi skillovi na jednom mjestu.** Skillovi koje imaš u Claude Codeu, Codexu i CROZ Codeu kopiraju se u bb i
  rade u svim agentima. Skill **croz-tools** (CROZ Confluence, GitLab, kolege, službeni dokumenti) tada radi
  i u Claude Codeu i Codexu.
- **Stari kontekst.** Ono što su agenti dosad naučili o tebi i tvojim projektima uvozi se u memoriju.

## Prije početka

- Mac s Apple čipom (M1 ili noviji).
- Claude pretplata (Pro ili Max) i ChatGPT pretplata (Plus ili Pro).
- Jarvis API ključ: https://jarvis.croz.net/onboarder
- CROZ VPN je uključen.

## Pokretanje

1. Na ovoj stranici klikni **Code → Download ZIP**. U Preuzimanjima (Downloads) dobiješ mapu
   `bb-setup-mac-main` (ako je ostao zip, otvori ga dvoklikom).
2. Pritisni **Cmd + razmak**, upiši `Terminal` i pritisni Enter.
3. Zalijepi ovu naredbu (**Cmd + V**) i pritisni Enter:

   ```sh
   bash ~/Downloads/bb-setup-mac-main/bootstrap.sh
   ```

   Ako Mac otvori prozor za **Command Line Tools**, klikni **Install**, pričekaj kraj i pokreni istu naredbu
   ponovno.
4. Codex se instalira i otvori preglednik: prijavi se svojim ChatGPT računom.
5. Ako Codex pita vjeruješ li ovoj mapi, potvrdi (Enter). Codex preuzima. Razgovaraj s njim na hrvatskom. Kad te zamoli da se negdje prijaviš ili nešto klikneš,
   učini to i napiši mu `gotovo`.

Želiš li da instalaciju vodi **Jarvis** (CROZ Code) umjesto Codexa:

```sh
bash ~/Downloads/bb-setup-mac-main/bootstrap.sh jarvis
```

## Što agent napravi

1. Provjeri stanje: `scripts/check.sh`.
2. Node.js: `scripts/install-node.sh`.
3. Claude Code, Codex i CROZ Code: `scripts/install-agents.sh`.
4. Zamoli te da se prijaviš u Claude Code i CROZ Code (Jarvis ključ upisuješ samo ti, u svoj Terminal).
5. Most Pi → CROZ Code: `scripts/bb-pi-most.sh`.
6. bb aplikacija i bb naredba: `scripts/install-bb-mac.sh`.
7. Zajednička memorija, skillovi i uvoz starog konteksta: `scripts/bb-harness.sh`.

Upute za agenta su u [AGENTS.md](AGENTS.md). Bez agenta: [VODIC.md](VODIC.md) (detaljno) ili [docs/RUCNO.md](docs/RUCNO.md) (kratko).
Video ručnog postupka: [docs/bb-mac-480p.mp4](docs/bb-mac-480p.mp4).

## Svaki dan

Otvori aplikaciju **bb**. Za agenta Pi (CROZ Code) uključi VPN.

## Ako nešto zapne

- Gdje je instalacija: `bash ~/Downloads/bb-setup-mac-main/scripts/check.sh`
- Pokreni `bootstrap.sh` ponovno: agent nastavlja od prvog koraka koji nije gotov.
- Memorije vidiš i uređuješ u bb-u: **Settings → Installed plugins → Memory**.
