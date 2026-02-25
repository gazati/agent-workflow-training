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

---

# Эшелонированная защита: объединение всех уровней

Ни один уровень не является абсолютно надёжным. Используйте все три вместе для максимальной защиты.

## Три уровня

```
Уровень 1: Deny-правила           — статическое сопоставление паттернов (быстро, просто)
Уровень 2: Хуки PreToolUse        — логика во время выполнения (гибко, настраиваемо)
Уровень 3: Управляемые настройки  — организационное принудительное применение (неотменяемо)
```

## Как они работают вместе

1. **Управляемые настройки** задают базовый уровень — deny-правила, которые никто не может удалить
2. **Проектные deny-правила** добавляют блокировки, специфичные для проекта (например, чтение `config/production.yml`)
3. **Хуки** перехватывают крайние случаи, которые паттерны пропускают (например, конвейерные команды, закодированные пути)

## Что перехватывает каждый уровень

| Вектор атаки | Deny-правила | Хуки | Управляемые настройки |
|---|---|---|---|
| `Read(.env)` | Да | Да | Да |
| `Bash(cat .env)` | Да | Да | Да |
| `Bash(cat .en\v)` (escape-символы) | Нет | Да (с regex) | Нет |
| `Bash(base64 .env)` | Нужен явный паттерн | Да | Нужен явный паттерн |
| Разработчик удаляет deny-правила | Уязвимо | Уязвимо | Защищено |
| Разработчик удаляет хуки | Уязвимо | Уязвимо | Защищено (с `allowManagedHooksOnly`) |

## Рекомендуемая настройка для команд

### Шаг 1: Администратор разворачивает управляемые настройки

`/etc/claude-code/managed-settings.json` — блокирует .env, секреты, SSH-ключи, переменные окружения

### Шаг 2: Каждый проект добавляет свои deny-правила

`.claude/settings.json` — блокирует конфиденциальные файлы, специфичные для проекта

### Шаг 3: (Необязательно) Добавить хуки для продвинутой логики

`.claude/hooks/` — перехватывает паттерны, которые статические правила пропускают

## Чеклист конфиденциальных файлов

Файлы, которые стоит блокировать во всех проектах:

- `.env`, `.env.*`, `.env.local`, `.env.production`
- `secrets/`, `credentials/`
- `*.pem`, `*.key`, `*.p12`
- `~/.ssh/*`
- `~/.aws/*`
- `~/.kube/config`
- `docker-compose*.yml` (могут содержать секреты)
- `*.tfvars` (переменные Terraform, часто содержат секреты)

## Чеклист опасных команд

Команды, которые стоит блокировать:

- `printenv`, `env`
- `echo $VARIABLE`
- `aws configure list`
- `cat /proc/*/environ`
- `history`
- `curl` / `wget` (предотвращает утечку данных на внешние URL)
