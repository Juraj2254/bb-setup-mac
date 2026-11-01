# Runbook: bb on a Mac (for the installing agent)

You are installing **bb** (an agent IDE, https://getbb.app) on this Mac for a CROZ colleague, together with three
agents and one shared memory. You are Codex or Jarvis (CROZ Code). Follow this runbook from top to bottom.

Goal, when you are done:

| In bb | Runs | Works on |
|---|---|---|
| Claude Code | Claude Code | the user's Claude subscription |
| Codex | Codex | the user's ChatGPT subscription |
| Pi | CROZ Code | Jarvis, the CROZ AI gateway (needs CROZ VPN) |

Plus: bb Memory (one memory for all agents), every skill from this computer in bb, and the user's earlier
Claude Code / Codex / CROZ Code context imported into that memory.

## How to work with the user

- Speak **Croatian**, short and plain. The user is usually not a programmer.
- Run the steps yourself. Ask the user only for what you cannot do: browser sign-ins, clicks in windows,
  typing a key or a password into their own terminal window.
- When the user must act, give **one** clear instruction: which window, what to type or click, what they
  will see when it worked. Then wait for them to say they are done ("gotovo"), and verify.
- Never ask the user to paste a password, token or API key into this chat. Keys go only into the program
  that asks for them, in the user's own terminal window.
- Every script here is safe to run again. If a step fails twice, stop, show the last lines of the error,
  and explain in one sentence what the user can do.
- Do not use `sudo`. Do not delete or overwrite the user's files outside what these scripts do.

## How to run commands

Every command must start by loading the tools the scripts install (your shell does not read `~/.zshrc`):

```sh
. scripts/env.sh && <command>
```

Run commands from the folder that contains this file. Some commands download a lot; let them finish.

## Step 0 – Where are we?

```sh
. scripts/env.sh && bash scripts/check.sh
```

Every line is ✔ (done) or ✘ (missing, with the next action). Tell the user in three sentences what you will do,
then continue with the first ✘ step below. Run `check.sh` again after each step.

## Step 1 – Apple Command Line Tools

If `xcode-select -p` fails: run `xcode-select --install`, then tell the user: "Otvorio se prozor. Klikni
**Install** i pričekaj kraj (nekoliko minuta)." Poll every 15 s with `xcode-select -p` (up to 30 minutes).

## Step 2 – Node.js

```sh
. scripts/env.sh && bash scripts/install-node.sh
```

## Step 3 – Install the agents

```sh
. scripts/env.sh && bash scripts/install-agents.sh
```

Exit code 3 means the CROZ Nexus is not reachable. Ask the user to turn on the **CROZ VPN**, then run
`bash scripts/install-agents.sh croz` again.

## Step 4 – Sign-ins (the user does these)

Check with `check.sh`. For each agent that is not signed in, ask the user to open a **new Terminal window**
(Cmd + N) and run one command there. Do them one at a time.

1. **Claude Code**: `claude`. On the first questions press Enter. Choose **Claude account with subscription**,
   sign in in the browser, click **Authorize**, then type `/exit`.
   Verify: `claude auth status` shows `"loggedIn": true`.
2. **Codex** (skip if you are Codex, you are already signed in): `codex login`, sign in with ChatGPT.
   Verify: `codex login status`.
3. **CROZ Code** (VPN on): `croz-code setup`, paste the Jarvis API key from https://jarvis.croz.net/onboarder,
   press Enter. It must print `✔ Saved. You are ready.` Verify with `check.sh`.

## Step 5 – Bridge Pi → CROZ Code

```sh
. scripts/env.sh && bash scripts/bb-pi-most.sh
```

## Step 6 – bb app

```sh
. scripts/env.sh && bash scripts/install-bb-mac.sh
```

It downloads bb for Apple Silicon into Applications, opens it, waits for it and installs the `bb` command.
On an Intel Mac it exits with code 3: then run `npm install -g bb-app`, start bb in the background with
`nohup bb-app start >/tmp/bb.log 2>&1 &`, and tell the user to open http://localhost:38886.

Then tell the user: "U prozoru bb klikni **Continue** dok Codex, Claude Code i Pi pišu **Ready**, a na
ostalim koracima **Skip**." If an agent is not Ready, ask the user to quit bb (Cmd + Q) and open it again
(bb reads the tools when it starts), then check again.

## Step 7 – Shared memory, skills and the earlier context

```sh
. scripts/env.sh && bash scripts/bb-harness.sh --yes
```

It puts the Pi bridge into bb, turns on the bb Memory plugin, turns off the agents' separate memories, writes
the shared rules to `~/.bb/AGENTS.md`, copies every skill on this Mac into `~/.bb/skills` (bb gives them to
every agent), gives bb the Jarvis key so the `croz-tools` skill works in every agent, collects the earlier
context into `~/.bb/legacy-context`, adds the earlier projects to bb and starts one "Uvoz konteksta" thread
per project plus a global one. Those threads write the memories; they take a minute or two each.

## Step 8 – Done

1. Run `check.sh`. Every line should be ✔.
2. Tell the user how to see the result: in bb, **Settings → Installed plugins → Memory** lists the memories.
3. Tell the user how to try it: in bb click **New thread**, open the model menu under the message box, choose
   the **Pi** tab (Jarvis Reason), and ask `Što znaš o meni i mojim projektima?`.
4. Every day: just open the **bb** app. For Pi (CROZ Code), turn on the VPN.

End with a short summary in Croatian: what is installed, what the user still has to do (if anything).
