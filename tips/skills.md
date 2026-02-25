# Skills & Slash Commands

Skills are reusable instructions stored as markdown. You create a skill once — then invoke it with `/skill-name` or let Claude trigger it automatically.

## Built-in Commands

These come with Claude Code out of the box:

| Command | What it does |
|---|---|
| `/help` | Show help |
| `/compact` | Compact conversation context |
| `/init` | Create a CLAUDE.md for your project |
| `/memory` | Open your memory files in the editor |
| `/cost` | Show token usage and cost |
| `/mcp` | Manage MCP servers |

## Custom Skills

You create these. They live as `SKILL.md` files in a directory structure.

### Where they live

| Scope | Path |
|---|---|
| Personal (all projects) | `~/.claude/skills/<name>/SKILL.md` |
| Project (this repo) | `./.claude/skills/<name>/SKILL.md` |

### Minimal example: `/deploy`

`.claude/skills/deploy/SKILL.md`:

```yaml
---
name: deploy
description: Deploy the app to production
disable-model-invocation: true
allowed-tools: Bash(npm *), Bash(git *)
---

## Deploy Steps

1. Run tests: `npm test`
2. Build: `npm run build`
3. Deploy: `npm run deploy:prod`
4. Verify the deployment

Report success or failure.
```

Usage: type `/deploy` in Claude Code.

### Example: `/fix-issue`

`.claude/skills/fix-issue/SKILL.md`:

```yaml
---
name: fix-issue
description: Fix a GitHub issue
disable-model-invocation: true
---

Fix GitHub issue $ARGUMENTS:

1. Read the issue description
2. Implement the fix
3. Write tests
4. Create a commit
```

Usage: `/fix-issue 456` — Claude receives "Fix GitHub issue 456".

### Example: auto-invoked guideline

`.claude/skills/api-conventions/SKILL.md`:

```yaml
---
name: api-conventions
description: API design patterns for this codebase
---

When writing API endpoints:

- Use RESTful naming: `/users`, `/users/:id`
- Return consistent error format: `{ "error": "...", "code": "..." }`
- Include request validation using Zod
```

No `disable-model-invocation` — Claude reads this automatically when relevant.

## Key Frontmatter Options

```yaml
---
name: my-skill                      # The /command name
description: What it does           # When to use (Claude reads this)
disable-model-invocation: true      # Only you can invoke, not Claude
allowed-tools: Read, Bash(npm *)    # Tools allowed without asking
argument-hint: "[issue-number]"     # Hint shown in autocomplete
---
```

## Arguments

Use `$ARGUMENTS` for the full argument string, or `$0`, `$1`, `$2` for positional:

```yaml
Migrate the $0 component from $1 to $2.
```

`/migrate SearchBar React Vue` → "Migrate the SearchBar component from React to Vue."

## Tips

- `disable-model-invocation: true` prevents Claude from accidentally triggering side-effect skills (deploy, send-email, etc.)
- Supporting files (checklists, examples) go in the skill directory — reference them in SKILL.md so Claude knows they exist
- The old `.claude/commands/` directory still works but `.claude/skills/` is preferred
- Skills auto-discover in subdirectories — monorepos can have per-package skills

---

# Навыки и слэш-команды

Навыки (Skills) — это переиспользуемые инструкции в виде markdown-файлов. Создаёте один раз — вызываете через `/имя-навыка` или Claude использует автоматически.

## Встроенные команды

Идут с Claude Code из коробки:

| Команда | Что делает |
|---|---|
| `/help` | Показать справку |
| `/compact` | Сжать контекст беседы |
| `/init` | Создать CLAUDE.md для проекта |
| `/memory` | Открыть файлы памяти в редакторе |
| `/cost` | Показать использование токенов и стоимость |
| `/mcp` | Управление MCP-серверами |

## Пользовательские навыки

Вы создаёте их сами. Это файлы `SKILL.md` в структуре директорий.

### Где они находятся

| Область | Путь |
|---|---|
| Личные (все проекты) | `~/.claude/skills/<имя>/SKILL.md` |
| Проект (этот репозиторий) | `./.claude/skills/<имя>/SKILL.md` |

### Минимальный пример: `/deploy`

`.claude/skills/deploy/SKILL.md`:

```yaml
---
name: deploy
description: Деплой приложения в продакшен
disable-model-invocation: true
allowed-tools: Bash(npm *), Bash(git *)
---

## Шаги деплоя

1. Запустить тесты: `npm test`
2. Собрать: `npm run build`
3. Задеплоить: `npm run deploy:prod`
4. Проверить деплой

Сообщить об успехе или неудаче.
```

Использование: введите `/deploy` в Claude Code.

### Пример: `/fix-issue`

`.claude/skills/fix-issue/SKILL.md`:

```yaml
---
name: fix-issue
description: Исправить issue на GitHub
disable-model-invocation: true
---

Исправить GitHub issue $ARGUMENTS:

1. Прочитать описание issue
2. Реализовать исправление
3. Написать тесты
4. Создать коммит
```

Использование: `/fix-issue 456` — Claude получает «Исправить GitHub issue 456».

### Пример: авто-вызываемое руководство

`.claude/skills/api-conventions/SKILL.md`:

```yaml
---
name: api-conventions
description: Паттерны проектирования API для этой кодовой базы
---

При написании API-эндпоинтов:

- RESTful именование: `/users`, `/users/:id`
- Единый формат ошибок: `{ "error": "...", "code": "..." }`
- Валидация запросов через Zod
```

Без `disable-model-invocation` — Claude читает это автоматически, когда уместно.

## Ключевые опции фронтматтера

```yaml
---
name: my-skill                      # Имя /команды
description: Что делает             # Когда использовать (Claude читает)
disable-model-invocation: true      # Только вы вызываете, не Claude
allowed-tools: Read, Bash(npm *)    # Инструменты без запроса
argument-hint: "[issue-number]"     # Подсказка в автодополнении
---
```

## Аргументы

`$ARGUMENTS` для всей строки аргументов, или `$0`, `$1`, `$2` для позиционных:

```yaml
Мигрировать компонент $0 с $1 на $2.
```

`/migrate SearchBar React Vue` → «Мигрировать компонент SearchBar с React на Vue.»

## Советы

- `disable-model-invocation: true` предотвращает случайный вызов Claude навыков с побочными эффектами (деплой, отправка email и т.д.)
- Вспомогательные файлы (чеклисты, примеры) помещайте в директорию навыка — ссылайтесь на них в SKILL.md
- Старая директория `.claude/commands/` работает, но `.claude/skills/` предпочтительнее
- Навыки автоматически обнаруживаются в поддиректориях — монорепы могут иметь навыки для каждого пакета
