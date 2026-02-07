#!/usr/bin/env bash
set -euo pipefail

# Himal installer — wires skills and extensions into ~/.pi/agent/

HIMAL_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$HOME/.pi/agent/skills"
EXTENSIONS_DIR="$HOME/.pi/agent/extensions"
REPOS_DIR="$HOME/repos"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${GREEN}[himal]${NC} $1"; }
warn() { echo -e "${YELLOW}[himal]${NC} $1"; }

mkdir -p "$SKILLS_DIR" "$EXTENSIONS_DIR" "$REPOS_DIR"

# --- Skills (copy directly) ---

info "Installing skills..."

for skill in orchestrator screenshot memory-search; do
  if [ -d "$SKILLS_DIR/$skill" ]; then
    warn "Skill '$skill' already exists — overwriting"
    rm -rf "$SKILLS_DIR/$skill"
  fi
  cp -r "$HIMAL_DIR/skills/$skill" "$SKILLS_DIR/$skill"
  info "  ✓ $skill"
done

# --- Extensions (clone repos + symlink) ---

info "Installing extensions..."

declare -A EXT_REPOS=(
  ["orchestrator"]="git@github.com:Aklaran/sirdar.git"
  ["diff-review"]="git@github.com:Aklaran/pi-diff.git"
  ["vim-editor"]="git@github.com:annapurna-himal/pi-vim-editor.git"
  ["memory-search"]="git@github.com:annapurna-himal/pi-memory-search.git"
)

declare -A EXT_DIRS=(
  ["orchestrator"]="orchestrator"
  ["diff-review"]="diff-review"
  ["vim-editor"]="pi-vim-editor"
  ["memory-search"]="pi-memory-search"
)

for ext in "${!EXT_REPOS[@]}"; do
  repo_url="${EXT_REPOS[$ext]}"
  repo_dir="$REPOS_DIR/${EXT_DIRS[$ext]}"

  if [ -d "$repo_dir" ]; then
    info "  $ext: repo exists at $repo_dir — pulling latest"
    git -C "$repo_dir" pull --ff-only 2>/dev/null || warn "  $ext: pull failed (not on tracking branch?)"
  else
    info "  $ext: cloning $repo_url"
    git clone "$repo_url" "$repo_dir"
  fi

  # Install dependencies if needed
  if [ -f "$repo_dir/package.json" ]; then
    if command -v pnpm &>/dev/null; then
      (cd "$repo_dir" && pnpm install --frozen-lockfile 2>/dev/null) || \
      (cd "$repo_dir" && pnpm install 2>/dev/null) || \
        warn "  $ext: pnpm install failed"
    elif [ -f "$repo_dir/package-lock.json" ]; then
      (cd "$repo_dir" && npm ci 2>/dev/null) || \
        warn "  $ext: npm ci failed"
    fi
  fi

  # Build if there's a build script
  if [ -f "$repo_dir/package.json" ] && grep -q '"build"' "$repo_dir/package.json"; then
    (cd "$repo_dir" && pnpm build 2>/dev/null) || warn "  $ext: build failed"
  fi

  # Symlink into extensions dir
  if [ -L "$EXTENSIONS_DIR/$ext" ]; then
    rm "$EXTENSIONS_DIR/$ext"
  elif [ -d "$EXTENSIONS_DIR/$ext" ]; then
    warn "  $ext: removing existing directory at $EXTENSIONS_DIR/$ext"
    rm -rf "$EXTENSIONS_DIR/$ext"
  fi
  ln -s "$repo_dir" "$EXTENSIONS_DIR/$ext"
  info "  ✓ $ext → $repo_dir"
done

# Memory-awareness (bundled, no separate repo)
if [ -L "$EXTENSIONS_DIR/memory-awareness" ]; then
  rm "$EXTENSIONS_DIR/memory-awareness"
elif [ -d "$EXTENSIONS_DIR/memory-awareness" ]; then
  rm -rf "$EXTENSIONS_DIR/memory-awareness"
fi
cp -r "$HIMAL_DIR/extensions/memory-awareness" "$EXTENSIONS_DIR/memory-awareness"
info "  ✓ memory-awareness (bundled)"

echo ""
info "Done! Restart Pi to load new skills and extensions."
info ""
info "Installed:"
info "  Skills:     $SKILLS_DIR/{orchestrator,screenshot,memory-search}"
info "  Extensions: $EXTENSIONS_DIR/{orchestrator,diff-review,vim-editor,memory-search,memory-awareness}"
