#!/usr/bin/env bash
# Install tooling that is not managed by Nix.
# Run this once after `nixos-rebuild switch` on a fresh install.

set -euo pipefail

log()  { printf '\n\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\n\033[1;33m!!\033[0m  %s\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

# ---- nvm ---------------------------------------------------------------------
if [ ! -d "$HOME/.nvm" ]; then
  log "Installing nvm"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
else
  warn "nvm already installed, skipping"
fi

# ---- sdkman ------------------------------------------------------------------
if [ ! -d "$HOME/.sdkman" ]; then
  log "Installing sdkman"
  curl -s "https://get.sdkman.io" | bash
else
  warn "sdkman already installed, skipping"
fi

# ---- claude-code -------------------------------------------------------------
if ! have claude; then
  log "Installing claude-code (npm global)"
  npm install -g @anthropic-ai/claude-code || warn "npm install failed; ensure nodejs is on PATH"
else
  warn "claude already installed, skipping"
fi

# ---- opencode ----------------------------------------------------------------
if [ ! -x "$HOME/.opencode/bin/opencode" ]; then
  log "Installing opencode"
  curl -fsSL https://opencode.ai/install | bash
else
  warn "opencode already installed, skipping"
fi

# ---- caa (Composio CLI daemon) ----------------------------------------------
if ! have caa; then
  warn "caa not installed - fetch the latest binary from the Composio release page"
  warn "  drop it into ~/.caa/bin/caa and chmod +x"
fi

# ---- cursor-agent ------------------------------------------------------------
if ! have cursor-agent; then
  log "Installing cursor-agent"
  curl https://cursor.com/install -fsS | bash || warn "cursor-agent install failed"
fi

# ---- kiro --------------------------------------------------------------------
if ! have kiro; then
  warn "kiro not installed - download from https://kiro.dev and place binary on PATH"
fi

# ---- composio ----------------------------------------------------------------
if ! have composio; then
  log "Installing composio (pipx)"
  pipx install composio-core || warn "pipx not available yet"
fi

log "Bootstrap complete. Restart your shell to pick up nvm/sdkman/bun paths."
