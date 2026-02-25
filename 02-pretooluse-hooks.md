# PreToolUse Hooks

Hooks are shell commands that run automatically before or after Claude Code uses a tool.
They provide runtime enforcement — custom logic that static deny patterns can't express.

## How it works

1. Claude Code is about to call a tool (e.g., `Read`, `Bash`, `Edit`)
2. Your hook script receives tool name + arguments as JSON on stdin
3. Your script inspects the input and decides: allow or deny
4. If it returns `{"decision": "deny"}`, the tool call is blocked

## Configuration

In `.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Read",
        "hooks": [{
          "type": "command",
          "command": "bash .claude/hooks/block-env-read.sh"
        }]
      },
      {
        "matcher": "Bash",
        "hooks": [{
          "type": "command",
          "command": "bash .claude/hooks/block-env-bash.sh"
        }]
      }
    ]
  }
}
```

- `matcher` — which tool to intercept: `Read`, `Bash`, `Edit`, `Write`, or `*` for all
- `command` — the shell command to run

## Example: block .env reads

`.claude/hooks/block-env-read.sh`:

```bash
#!/bin/bash
input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

if [[ "$file_path" =~ \.env ]]; then
  echo '{"decision": "deny"}'
  exit 0
fi

if [[ "$file_path" =~ secrets|credentials|password ]]; then
  echo '{"decision": "deny"}'
  exit 0
fi

# Allow everything else
exit 0
```

## Example: block env var exposure via Bash

`.claude/hooks/block-env-bash.sh`:

```bash
#!/bin/bash
input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // empty')

if [[ "$command" =~ (printenv|^env$|^env\ |echo\ \$|cat.*\.env) ]]; then
  echo '{"decision": "deny"}'
  exit 0
fi

exit 0
```

## When to use hooks vs deny rules

| Deny rules | Hooks |
|---|---|
| Simple pattern matching | Custom logic (regex, multi-field checks) |
| No code to maintain | Requires a script |
| Static — can't inspect content | Dynamic — can inspect full tool input |
| Faster | Slightly slower (spawns a process) |

Use deny rules for straightforward blocks. Use hooks when you need logic that patterns can't express (e.g., "block Bash commands that contain both `cat` and `.env` anywhere in the string").

## Available hook events

| Event | When it runs |
|---|---|
| `PreToolUse` | Before a tool is called — can deny |
| `PostToolUse` | After a tool completes — can inspect results |
| `UserPromptSubmit` | When the user submits a message |

---

# Хуки PreToolUse

Хуки — это shell-команды, которые автоматически запускаются до или после использования инструмента Claude Code.
Они обеспечивают контроль во время выполнения — пользовательскую логику, которую статические deny-паттерны не могут выразить.

## Как это работает

1. Claude Code собирается вызвать инструмент (например, `Read`, `Bash`, `Edit`)
2. Ваш скрипт-хук получает имя инструмента и аргументы как JSON на stdin
3. Скрипт проверяет входные данные и решает: разрешить или запретить
4. Если возвращает `{"decision": "deny"}`, вызов инструмента блокируется

## Конфигурация

В `.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Read",
        "hooks": [{
          "type": "command",
          "command": "bash .claude/hooks/block-env-read.sh"
        }]
      },
      {
        "matcher": "Bash",
        "hooks": [{
          "type": "command",
          "command": "bash .claude/hooks/block-env-bash.sh"
        }]
      }
    ]
  }
}
```

- `matcher` — какой инструмент перехватывать: `Read`, `Bash`, `Edit`, `Write` или `*` для всех
- `command` — shell-команда для запуска

## Пример: блокировка чтения .env

`.claude/hooks/block-env-read.sh`:

```bash
#!/bin/bash
input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

if [[ "$file_path" =~ \.env ]]; then
  echo '{"decision": "deny"}'
  exit 0
fi

if [[ "$file_path" =~ secrets|credentials|password ]]; then
  echo '{"decision": "deny"}'
  exit 0
fi

# Разрешить всё остальное
exit 0
```

## Пример: блокировка утечки переменных окружения через Bash

`.claude/hooks/block-env-bash.sh`:

```bash
#!/bin/bash
input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // empty')

if [[ "$command" =~ (printenv|^env$|^env\ |echo\ \$|cat.*\.env) ]]; then
  echo '{"decision": "deny"}'
  exit 0
fi

exit 0
```

## Когда использовать хуки, а когда deny-правила

| Deny-правила | Хуки |
|---|---|
| Простое сопоставление паттернов | Пользовательская логика (regex, проверка нескольких полей) |
| Не нужно поддерживать код | Требуется скрипт |
| Статические — не могут проверять содержимое | Динамические — могут проверять весь ввод инструмента |
| Быстрее | Немного медленнее (запускает процесс) |

Используйте deny-правила для простых блокировок. Используйте хуки, когда нужна логика, которую паттерны не могут выразить (например, «блокировать bash-команды, содержащие одновременно `cat` и `.env` в любом месте строки»).

## Доступные события хуков

| Событие | Когда запускается |
|---|---|
| `PreToolUse` | Перед вызовом инструмента — может запретить |
| `PostToolUse` | После завершения инструмента — может проверить результат |
| `UserPromptSubmit` | При отправке сообщения пользователем |
