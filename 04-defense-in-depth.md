# Defense in Depth: Combining All Layers

No single layer is foolproof. Use all three together for maximum protection.

## The three layers

```
Layer 1: Deny Rules          — static pattern matching (fast, simple)
Layer 2: PreToolUse Hooks    — runtime logic (flexible, custom)
Layer 3: Managed Settings    — organization-wide enforcement (non-overridable)
```

## How they work together

1. **Managed settings** set the baseline — deny rules that no one can remove
2. **Project deny rules** add project-specific blocks (e.g., block reading `config/production.yml`)
3. **Hooks** catch edge cases that patterns miss (e.g., piped commands, encoded paths)

## What each layer catches

| Attack vector | Deny rules | Hooks | Managed settings |
|---|---|---|---|
| `Read(.env)` | Yes | Yes | Yes |
| `Bash(cat .env)` | Yes | Yes | Yes |
| `Bash(cat .en\v)` (escape chars) | No | Yes (with regex) | No |
| `Bash(base64 .env)` | Need explicit pattern | Yes | Need explicit pattern |
| Developer removes deny rules | Vulnerable | Vulnerable | Protected |
| Developer removes hooks | Vulnerable | Vulnerable | Protected (with `allowManagedHooksOnly`) |

## Recommended setup for teams

### Step 1: Admin deploys managed settings

`/etc/claude-code/managed-settings.json` — blocks .env, secrets, SSH keys, env vars

### Step 2: Each project adds its own deny rules

`.claude/settings.json` — blocks project-specific sensitive files

### Step 3: (Optional) Add hooks for advanced logic

`.claude/hooks/` — catches patterns that static rules miss

## Sensitive file checklist

Files to consider blocking across all projects:

- `.env`, `.env.*`, `.env.local`, `.env.production`
- `secrets/`, `credentials/`
- `*.pem`, `*.key`, `*.p12`
- `~/.ssh/*`
- `~/.aws/*`
- `~/.kube/config`
- `docker-compose*.yml` (may contain inline secrets)
- `*.tfvars` (Terraform variables, often contain secrets)

## Sensitive commands checklist

Commands to consider blocking:

- `printenv`, `env`
- `echo $VARIABLE`
- `aws configure list`
- `cat /proc/*/environ`
- `history`
- `curl` / `wget` (prevents exfiltration to external URLs)
