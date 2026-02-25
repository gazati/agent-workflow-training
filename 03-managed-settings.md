# Managed Settings (Organization-Wide Enforcement)

Managed settings are the strongest layer. They are set by an admin at the OS level and cannot be overridden by developers in their project or user settings.

## File location

| OS | Path |
|---|---|
| Linux / WSL | `/etc/claude-code/managed-settings.json` |
| macOS | `/Library/Application Support/ClaudeCode/managed-settings.json` |
| Windows | `C:\Program Files\ClaudeCode\managed-settings.json` |

## Example: lock down .env access organization-wide

```json
{
  "permissions": {
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./secrets/**)",
      "Read(~/.ssh/**)",
      "Read(~/.aws/**)",
      "Read(~/.kube/**)",
      "Bash(printenv *)",
      "Bash(env)",
      "Bash(env *)",
      "Bash(echo $*)",
      "Bash(echo ${*})",
      "Bash(cat .env*)",
      "Bash(cat */.env*)"
    ]
  },
  "allowManagedPermissionRulesOnly": true,
  "allowManagedHooksOnly": true
}
```

## Key flags

| Flag | Effect |
|---|---|
| `allowManagedPermissionRulesOnly` | Ignores permission rules from project and user settings — only managed rules apply |
| `allowManagedHooksOnly` | Ignores hooks from project and user settings — only managed hooks apply |

## Deployment

1. Create the managed settings file at the OS-level path above
2. Set file permissions so developers cannot modify it (owned by root, read-only for others)
3. Distribute via your configuration management tool (Ansible, Chef, Puppet, etc.)

## Why this matters

- Project-level `.claude/settings.json` — a developer can edit or remove deny rules
- User-level `~/.claude/settings.json` — same problem, the developer controls it
- Managed settings — only an admin with root/sudo can modify them

For environments where sensitive credentials exist on developer machines, managed settings are the only way to guarantee enforcement.

---

# Управляемые настройки (Managed Settings) — организационное принудительное применение

Управляемые настройки — самый сильный уровень. Они устанавливаются администратором на уровне ОС и не могут быть переопределены разработчиками в их проектных или пользовательских настройках.

## Расположение файла

| ОС | Путь |
|---|---|
| Linux / WSL | `/etc/claude-code/managed-settings.json` |
| macOS | `/Library/Application Support/ClaudeCode/managed-settings.json` |
| Windows | `C:\Program Files\ClaudeCode\managed-settings.json` |

## Пример: заблокировать доступ к .env на уровне организации

```json
{
  "permissions": {
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./secrets/**)",
      "Read(~/.ssh/**)",
      "Read(~/.aws/**)",
      "Read(~/.kube/**)",
      "Bash(printenv *)",
      "Bash(env)",
      "Bash(env *)",
      "Bash(echo $*)",
      "Bash(echo ${*})",
      "Bash(cat .env*)",
      "Bash(cat */.env*)"
    ]
  },
  "allowManagedPermissionRulesOnly": true,
  "allowManagedHooksOnly": true
}
```

## Ключевые флаги

| Флаг | Эффект |
|---|---|
| `allowManagedPermissionRulesOnly` | Игнорирует правила разрешений из проектных и пользовательских настроек — применяются только управляемые правила |
| `allowManagedHooksOnly` | Игнорирует хуки из проектных и пользовательских настроек — применяются только управляемые хуки |

## Развёртывание

1. Создайте файл управляемых настроек по пути ОС, указанному выше
2. Установите права доступа, чтобы разработчики не могли его изменить (владелец root, только чтение для остальных)
3. Распространяйте через систему управления конфигурацией (Ansible, Chef, Puppet и т.д.)

## Почему это важно

- `.claude/settings.json` на уровне проекта — разработчик может отредактировать или удалить deny-правила
- `~/.claude/settings.json` на уровне пользователя — та же проблема, разработчик контролирует файл
- Управляемые настройки — только администратор с root/sudo может их изменить

Для сред, где на машинах разработчиков существуют конфиденциальные учётные данные, управляемые настройки — единственный способ гарантировать соблюдение правил.
