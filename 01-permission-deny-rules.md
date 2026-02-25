# Permission Deny Rules

Deny rules are the simplest way to prevent Claude Code from accessing sensitive files or running dangerous commands.

## How it works

Rules are evaluated in order: **deny > ask > allow** (first match wins).
A deny rule blocks the action silently — Claude Code cannot override it.

## Configuration

Add to `.claude/settings.json` at the project root:

```json
{
  "permissions": {
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./.env.local)",
      "Read(./secrets/**)",
      "Read(~/.ssh/**)",
      "Read(~/.aws/**)",
      "Bash(printenv *)",
      "Bash(env)",
      "Bash(env *)",
      "Bash(echo $*)",
      "Bash(echo ${*})",
      "Bash(cat .env*)"
    ]
  }
}
```

## Pattern syntax

- `Read(./.env)` — blocks reading a specific file
- `Read(./.env.*)` — wildcard: blocks `.env.local`, `.env.production`, etc.
- `Read(./secrets/**)` — recursive: blocks everything under `secrets/`
- `Bash(printenv *)` — blocks any bash command starting with `printenv`

## Scope levels

| File location | Scope |
|---|---|
| `.claude/settings.json` (in project root) | Project-level, applies to all users in the repo |
| `~/.claude/settings.json` | User-level, applies to all projects for this user |
| `/etc/claude-code/managed-settings.json` | Organization-level, cannot be overridden (see 03-managed-settings.md) |

## Important

- Deny rules are static patterns — they match on tool name and argument strings
- A developer with access to the project `.claude/settings.json` can remove these rules
- For enforced, non-overridable rules, use managed settings (see 03-managed-settings.md)
