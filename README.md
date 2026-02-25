# Claude Code Security Setup

This guide gets you from zero to a working security baseline for Claude Code.
It covers CLI and IDE (VS Code, JetBrains) usage.

## Prerequisites

- Claude Code installed
- `jq` available on your system (`apt install jq` / `brew install jq`)

## Quick Start

Clone this repo and run the installer:

```bash
git clone <repo-url> && cd agent-workflow-training
bash install.sh
```

This installs:
- **User-level** (`~/.claude/`) — applies to all your projects
- **Project-level** (`.claude/` in cwd) — applies to the current repo, if you're in one

You can also target a specific level:

```bash
bash install.sh --user      # user level only
bash install.sh --project   # project level only
bash install.sh --both      # both, regardless of .git
```

## What Gets Installed

### 1. Permission Deny Rules

Static patterns that block access to sensitive files and commands.
Added to your `settings.json`:

Both layers cover both sets of files — deny rules and the hook each protect sensitive data **and** security configs. If one layer is bypassed, the other still catches it.

**Sensitive data** — `.env`, `.env.*`, `secrets/`, `~/.ssh/`, `~/.aws/`, env var commands
**Security configs** — `.claude/settings.json`, `.claude/settings.local.json`, `.claude/hooks/`, `.idea/runConfigurations/`, `.run/`

### 1. Permission Deny Rules

Static patterns that block access outright. Added to your `settings.json`:

```json
{
  "permissions": {
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./secrets/**)",
      "Read(~/.ssh/**)",
      "Read(~/.aws/**)",
      "Bash(printenv *)",
      "Bash(env)",
      "Bash(env *)",
      "Bash(echo $*)",
      "Bash(echo ${*})",
      "Bash(cat .env*)",
      "Edit(./.claude/settings.json)",
      "Edit(./.claude/settings.local.json)",
      "Edit(./.claude/hooks/**)",
      "Write(./.claude/settings.json)",
      "Write(./.claude/settings.local.json)",
      "Write(./.claude/hooks/**)",
      "Edit(./.idea/runConfigurations/**)",
      "Edit(./.run/**)",
      "Write(./.idea/runConfigurations/**)",
      "Write(./.run/**)"
    ]
  }
}
```

See [01-permission-deny-rules.md](01-permission-deny-rules.md) for syntax details.

### 2. Guard Hook (PreToolUse)

A runtime hook that forces **manual approval** whenever Claude tries to edit any of the above files. This is the fallback — if deny rules are somehow removed or bypassed, the hook still catches the attempt.

In JetBrains specifically, Claude in auto-edit mode can write IDE run configs that auto-execute, bypassing bash permission prompts entirely. The hook catches this.

See [02-pretooluse-hooks.md](02-pretooluse-hooks.md) for how hooks work.

### 3. Settings Scope

The installer writes to two locations:

| Location | Who controls it | Can Claude override it? |
|---|---|---|
| `.claude/settings.json` (project) | Checked into the repo | Yes, if auto-edit is on |
| `~/.claude/settings.json` (user) | On your machine | Yes, if auto-edit is on |

That's why the guard hook exists — it catches those edits before they happen silently.

For organization-wide enforcement that **cannot** be overridden, an admin deploys managed settings. See [03-managed-settings.md](03-managed-settings.md).

## Verify

After installing, test that the hook fires:

1. Open Claude Code in any project
2. Ask Claude to edit `.claude/settings.json`
3. You should see a manual approval prompt instead of auto-approval

## Further Reading

- [01-permission-deny-rules.md](01-permission-deny-rules.md) — deny rule syntax and patterns
- [02-pretooluse-hooks.md](02-pretooluse-hooks.md) — how hooks work, examples
- [03-managed-settings.md](03-managed-settings.md) — organization-wide enforcement
- [04-defense-in-depth.md](04-defense-in-depth.md) — how the layers combine, attack vector coverage
