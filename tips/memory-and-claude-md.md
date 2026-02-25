# Memory & CLAUDE.md Files

## CLAUDE.md — Project Instructions

CLAUDE.md files are persistent instructions that Claude reads at the start of every session. You write them once — Claude follows them always.

### Where they live

| Scope | Path | Shared via git? |
|---|---|---|
| Global (you, all projects) | `~/.claude/CLAUDE.md` | No |
| Project (team) | `./CLAUDE.md` or `./.claude/CLAUDE.md` | Yes |
| Project local (you, this project) | `./CLAUDE.local.md` | No (auto-gitignored) |
| Modular rules | `./.claude/rules/*.md` | Yes |

More specific scopes override broader ones. Nested `CLAUDE.md` files in subdirectories load on-demand when Claude reads files there.

### Example: project CLAUDE.md

```markdown
# Project Rules

- Use 2-space indentation for YAML, 4 for Python
- All SQL migrations require explicit up/down logic
- Test all changes with `npm run test` before committing
```

### Example: personal global CLAUDE.md

```markdown
# My Preferences

- I prefer concise, technical explanations
- Always show file paths as absolute paths
```

### Example: modular rule (`.claude/rules/security.md`)

```yaml
---
paths:
  - "src/**/*.ts"
---

# TypeScript Security

- Never log credentials or API keys
- Validate all user input at API boundaries
```

The `paths` frontmatter makes the rule load only when Claude reads files matching those patterns.

### Tips

- `CLAUDE.local.md` is auto-gitignored — use it for personal sandbox URLs or test data
- Child `CLAUDE.md` in subdirectories only load on-demand (not at startup)
- Keep project `CLAUDE.md` short and actionable — it's not documentation, it's instructions

## Auto-Memory — Claude's Notebook

Auto-memory is where Claude saves what it learns across sessions. Unlike CLAUDE.md (you write), memory is what Claude writes.

### Where it lives

```
~/.claude/projects/<project>/memory/
├── MEMORY.md          ← first 200 lines load at startup
├── debugging.md       ← detailed notes, loaded on-demand
├── patterns.md
└── ...
```

Each project gets its own memory directory. It's per-user, per-machine — not shared.

### How to use it

- **Ask Claude to remember**: "Remember that we use pnpm, not npm" — Claude writes it to MEMORY.md
- **Ask Claude to forget**: "Stop remembering X" — Claude removes the entry
- **View/edit manually**: `/memory` command opens your memory files in the editor

### The 200-line rule

Only the first 200 lines of `MEMORY.md` load at session startup. Keep it as a concise index and move detailed notes into separate topic files that Claude reads on-demand.

### Tips

- Auto-memory is local to your machine — switching machines means starting fresh
- Git worktrees get separate memory directories
- Don't put secrets in memory files — they're plain text on disk

---

# Память и файлы CLAUDE.md

## CLAUDE.md — инструкции для проекта

Файлы CLAUDE.md — это постоянные инструкции, которые Claude читает в начале каждой сессии. Вы пишете их один раз — Claude следует им всегда.

### Где они находятся

| Область | Путь | В git? |
|---|---|---|
| Глобально (вы, все проекты) | `~/.claude/CLAUDE.md` | Нет |
| Проект (команда) | `./CLAUDE.md` или `./.claude/CLAUDE.md` | Да |
| Проект локально (вы, этот проект) | `./CLAUDE.local.md` | Нет (авто-gitignore) |
| Модульные правила | `./.claude/rules/*.md` | Да |

Более узкая область переопределяет широкую. Вложенные `CLAUDE.md` в подкаталогах загружаются по требованию, когда Claude читает файлы оттуда.

### Пример: проектный CLAUDE.md

```markdown
# Правила проекта

- Отступы: 2 пробела для YAML, 4 для Python
- Все SQL-миграции должны иметь явную логику up/down
- Тестировать все изменения через `npm run test` перед коммитом
```

### Пример: персональный глобальный CLAUDE.md

```markdown
# Мои предпочтения

- Предпочитаю краткие, технические объяснения
- Всегда показывать абсолютные пути к файлам
```

### Пример: модульное правило (`.claude/rules/security.md`)

```yaml
---
paths:
  - "src/**/*.ts"
---

# Безопасность TypeScript

- Никогда не логировать учётные данные или API-ключи
- Валидировать весь пользовательский ввод на границах API
```

Фронтматтер `paths` загружает правило только когда Claude читает файлы, соответствующие паттернам.

### Советы

- `CLAUDE.local.md` авто-gitignored — используйте для личных URL песочницы или тестовых данных
- Дочерние `CLAUDE.md` в подкаталогах загружаются по требованию (не при старте)
- Держите проектный `CLAUDE.md` коротким и конкретным — это инструкции, не документация

## Авто-память — блокнот Claude

Авто-память — это место, куда Claude сохраняет то, что узнаёт между сессиями. В отличие от CLAUDE.md (пишете вы), память пишет Claude.

### Где находится

```
~/.claude/projects/<проект>/memory/
├── MEMORY.md          ← первые 200 строк загружаются при старте
├── debugging.md       ← подробные заметки, загружаются по требованию
├── patterns.md
└── ...
```

У каждого проекта своя директория памяти. Она локальна для пользователя и машины.

### Как использовать

- **Попросить Claude запомнить**: «Запомни, что мы используем pnpm, а не npm» — Claude запишет в MEMORY.md
- **Попросить забыть**: «Перестань помнить X» — Claude удалит запись
- **Просмотр/редактирование**: команда `/memory` открывает файлы памяти в редакторе

### Правило 200 строк

Только первые 200 строк `MEMORY.md` загружаются при старте сессии. Держите его как краткий индекс, а подробности выносите в отдельные файлы.

### Советы

- Авто-память локальна для вашей машины — при смене машины начинаете с нуля
- Git worktree получают отдельные директории памяти
- Не храните секреты в файлах памяти — это обычный текст на диске
