# MCP Servers

MCP (Model Context Protocol) servers connect Claude to external tools — databases, GitHub, Sentry, Supabase, and more. You configure them once and Claude gets new capabilities.

## Configuration

Add a `.mcp.json` file at the project root (shared via git) or use `~/.claude.json` for personal servers.

### Scopes

| Scope | Path | Shared? |
|---|---|---|
| Project | `./.mcp.json` | Yes (git) |
| User | `~/.claude.json` | No |

Project-scoped servers require a one-time approval on first use.

## Format

```json
{
  "mcpServers": {
    "server-name": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@some/mcp-server"],
      "env": {
        "API_KEY": "${MY_API_KEY}"
      }
    }
  }
}
```

Two server types:
- **stdio** — local process (npx, node, python)
- **http** — remote HTTP server

Environment variables are supported with `${VAR}` or `${VAR:-default}` syntax.

## Examples

### PostgreSQL (query your database)

```bash
claude mcp add --transport stdio --scope project \
  db -- npx -y @bytebase/dbhub \
  --dsn "postgresql://user:pass@localhost:5432/mydb"
```

Now Claude can answer: "What's the total revenue this month?" by running SQL.

### GitHub

```bash
claude mcp add --transport http --scope project \
  github https://api.githubcopilot.com/mcp/
```

Now Claude can: "Review PR #123", "Show open issues labeled bug".

### Supabase

```bash
claude mcp add --transport stdio --scope project \
  --env SUPABASE_URL=https://myproject.supabase.co \
  --env SUPABASE_KEY=YOUR_KEY \
  supabase -- npx -y @supabase/mcp-server
```

### Sentry (error monitoring)

```bash
claude mcp add --transport http --scope project \
  sentry https://mcp.sentry.dev/mcp
```

Then run `/mcp` to authenticate.

### Filesystem (give Claude access to a specific directory)

```bash
claude mcp add --transport stdio --scope project \
  filesystem -- npx -y @modelcontextprotocol/server-filesystem /home/user/data
```

## Tips

- Use `claude mcp list` to see configured servers
- Use `claude mcp remove <name>` to remove a server
- On Windows (not WSL), wrap npx with `cmd /c`: `-- cmd /c npx -y @some/package`
- Many MCP servers exist — check [modelcontextprotocol.io](https://modelcontextprotocol.io) for the directory
- MCP tool descriptions consume context — don't add servers you won't use

---

# MCP-серверы

MCP (Model Context Protocol) серверы подключают Claude к внешним инструментам — базам данных, GitHub, Sentry, Supabase и другим. Настраиваете один раз — Claude получает новые возможности.

## Конфигурация

Добавьте файл `.mcp.json` в корень проекта (общий через git) или используйте `~/.claude.json` для личных серверов.

### Области действия

| Область | Путь | Общий? |
|---|---|---|
| Проект | `./.mcp.json` | Да (git) |
| Пользователь | `~/.claude.json` | Нет |

Проектные серверы требуют одноразового подтверждения при первом использовании.

## Формат

```json
{
  "mcpServers": {
    "имя-сервера": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@some/mcp-server"],
      "env": {
        "API_KEY": "${MY_API_KEY}"
      }
    }
  }
}
```

Два типа серверов:
- **stdio** — локальный процесс (npx, node, python)
- **http** — удалённый HTTP-сервер

Переменные окружения поддерживаются через `${VAR}` или `${VAR:-default}`.

## Примеры

### PostgreSQL (запросы к базе данных)

```bash
claude mcp add --transport stdio --scope project \
  db -- npx -y @bytebase/dbhub \
  --dsn "postgresql://user:pass@localhost:5432/mydb"
```

Теперь Claude может отвечать: «Какой общий доход в этом месяце?» через SQL.

### GitHub

```bash
claude mcp add --transport http --scope project \
  github https://api.githubcopilot.com/mcp/
```

Теперь Claude может: «Проверь PR #123», «Покажи открытые issues с меткой bug».

### Supabase

```bash
claude mcp add --transport stdio --scope project \
  --env SUPABASE_URL=https://myproject.supabase.co \
  --env SUPABASE_KEY=YOUR_KEY \
  supabase -- npx -y @supabase/mcp-server
```

### Sentry (мониторинг ошибок)

```bash
claude mcp add --transport http --scope project \
  sentry https://mcp.sentry.dev/mcp
```

Затем выполните `/mcp` для аутентификации.

### Файловая система (доступ Claude к определённой директории)

```bash
claude mcp add --transport stdio --scope project \
  filesystem -- npx -y @modelcontextprotocol/server-filesystem /home/user/data
```

## Советы

- `claude mcp list` — посмотреть настроенные серверы
- `claude mcp remove <name>` — удалить сервер
- На Windows (не WSL) оберните npx: `-- cmd /c npx -y @some/package`
- Каталог MCP-серверов: [modelcontextprotocol.io](https://modelcontextprotocol.io)
- Описания инструментов MCP занимают контекст — не добавляйте серверы, которые не используете
