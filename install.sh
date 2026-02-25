#!/bin/bash
# install.sh
#
# Installs Claude Code security defaults:
#   - Permission deny rules (block .env, secrets, SSH keys, env vars)
#   - Guard hook (force manual approval on security config edits)
#
# Default behavior:
#   - Always installs to ~/.claude (user level)
#   - Also installs to .claude/ (project level) if cwd has a .git directory
#
# Usage:
#   ./install.sh            # default: user + project if in a git repo
#   ./install.sh --user     # user level only
#   ./install.sh --project  # project level only
#   ./install.sh --both     # both levels regardless of .git

set -euo pipefail

if ! command -v jq &>/dev/null; then
  echo "Error: jq is required but not installed."
  exit 1
fi

# --- embedded hook script ---

HOOK_SCRIPT='#!/bin/bash
input=$(cat)
file_path=$(echo "$input" | jq -r '"'"'.tool_input.file_path // empty'"'"')

if [ -z "$file_path" ]; then
  exit 0
fi

PROTECTED_PATTERNS=(
  '"'"'\.claude/settings\.json$'"'"'
  '"'"'\.claude/settings\.local\.json$'"'"'
  '"'"'\.claude/hooks/'"'"'
  '"'"'\.idea/runConfigurations/'"'"'
  '"'"'\.run/'"'"'
  '"'"'\.env'"'"'
  '"'"'secrets/'"'"'
  '"'"'credentials/'"'"'
  '"'"'\.ssh/'"'"'
  '"'"'\.aws/'"'"'
)

for pattern in "${PROTECTED_PATTERNS[@]}"; do
  if [[ "$file_path" =~ $pattern ]]; then
    cat <<'"'"'HOOK_EOF'"'"'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "ask",
    "permissionDecisionReason": "This file is a security config — manual approval required."
  }
}
HOOK_EOF
    exit 0
  fi
done

exit 0'

# --- deny rules baseline ---

DENY_RULES='[
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
]'

# --- helpers ---

write_hook() {
  local dest_dir="$1"
  mkdir -p "$dest_dir"
  echo "$HOOK_SCRIPT" > "$dest_dir/guard-security-configs.sh"
  chmod +x "$dest_dir/guard-security-configs.sh"
  echo "  Wrote hook to $dest_dir/guard-security-configs.sh"
}

apply_settings() {
  local settings_file="$1"
  local hook_command="$2"

  local new_settings
  new_settings=$(cat <<TMPL
{
  "permissions": {
    "deny": $DENY_RULES
  },
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit",
        "hooks": [{ "type": "command", "command": "$hook_command" }]
      },
      {
        "matcher": "Write",
        "hooks": [{ "type": "command", "command": "$hook_command" }]
      }
    ]
  }
}
TMPL
  )

  if [ -f "$settings_file" ]; then
    local existing
    existing=$(cat "$settings_file")

    if echo "$existing" | jq -e '.hooks.PreToolUse' &>/dev/null; then
      echo "  Warning: $settings_file already has PreToolUse hooks — skipping hooks, merge manually if needed."
    fi

    if echo "$existing" | jq -e '.permissions.deny' &>/dev/null; then
      echo "  Warning: $settings_file already has deny rules — skipping deny rules, merge manually if needed."
    fi

    echo "$existing" | jq --argjson new "$new_settings" '
      ($new * .) as $base |
      if (.permissions.deny | not) then $base * {permissions: {deny: $new.permissions.deny}} else $base end |
      if (.hooks.PreToolUse | not) then . * {hooks: {PreToolUse: $new.hooks.PreToolUse}} else . end
    ' > "${settings_file}.tmp"
    mv "${settings_file}.tmp" "$settings_file"
  else
    mkdir -p "$(dirname "$settings_file")"
    echo "$new_settings" | jq '.' > "$settings_file"
  fi

  echo "  Updated $settings_file"
}

install_user() {
  echo "Installing user-level (~/.claude) ..."
  write_hook "$HOME/.claude/hooks"
  apply_settings "$HOME/.claude/settings.json" "bash ~/.claude/hooks/guard-security-configs.sh"
  echo "  Done."
}

install_project() {
  echo "Installing project-level (.claude/) ..."
  write_hook ".claude/hooks"
  apply_settings ".claude/settings.json" "bash .claude/hooks/guard-security-configs.sh"
  echo "  Done."
}

# --- main ---

MODE="${1:-}"

case "$MODE" in
  --user)
    install_user
    ;;
  --project)
    install_project
    ;;
  --both)
    install_user
    install_project
    ;;
  "")
    install_user
    if [ -d ".git" ]; then
      install_project
    else
      echo "No .git in cwd — skipping project-level install."
    fi
    ;;
  *)
    echo "Usage: $0 [--user|--project|--both]"
    exit 1
    ;;
esac

echo ""
echo "Installation complete. Restart Claude Code for hooks to take effect."
