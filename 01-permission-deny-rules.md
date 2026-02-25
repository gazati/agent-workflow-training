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

---

# Deny-правила (Permission Deny Rules)

Deny-правила — самый простой способ запретить Claude Code доступ к конфиденциальным файлам или запуск опасных команд.

## Как это работает

Правила проверяются по приоритету: **deny > ask > allow** (первое совпадение побеждает).
Deny-правило молча блокирует действие — Claude Code не может его обойти.

## Конфигурация

Добавьте в `.claude/settings.json` в корне проекта:

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

## Синтаксис паттернов

- `Read(./.env)` — блокирует чтение конкретного файла
- `Read(./.env.*)` — подстановка: блокирует `.env.local`, `.env.production` и т.д.
- `Read(./secrets/**)` — рекурсивно: блокирует всё внутри `secrets/`
- `Bash(printenv *)` — блокирует любую bash-команду, начинающуюся с `printenv`

## Уровни действия

| Расположение файла | Область действия |
|---|---|
| `.claude/settings.json` (в корне проекта) | Уровень проекта, применяется ко всем пользователям в репозитории |
| `~/.claude/settings.json` | Уровень пользователя, применяется ко всем проектам этого пользователя |
| `/etc/claude-code/managed-settings.json` | Уровень организации, невозможно переопределить (см. 03-managed-settings.md) |

## Важно

- Deny-правила — это статические паттерны, сопоставляемые с именем инструмента и строкой аргументов
- Разработчик с доступом к `.claude/settings.json` проекта может удалить эти правила
- Для принудительных, неотменяемых правил используйте managed settings (см. 03-managed-settings.md)
