#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
STOW_PACKAGES=(bash tmux nvim i3 ranger docker npm pip gtk ghostty)

usage() {
  echo "Usage: $0 {install|stow|unstow|all}"
  echo ""
  echo "  install  - Install system packages via apt"
  echo "  stow     - Deploy dotfiles via GNU Stow"
  echo "  unstow   - Remove dotfile symlinks"
  echo "  all      - Run install + stow"
}

do_install() {
  echo "==> Installing system packages..."
  sudo apt update
  sudo apt install -y \
    stow \
    git \
    i3-wm \
    i3blocks \
    feh \
    scrot \
    imagemagick \
    brightnessctl \
    playerctl \
    xautolock \
    ranger \
    neovim \
    tmux \
    arc-theme \
    fonts-font-awesome \
    ripgrep

  # Install vim-plug for neovim (if not present)
  PLUG_VIM="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"
  if [ ! -f "$PLUG_VIM" ]; then
    echo "==> Installing vim-plug..."
    curl -fLo "$PLUG_VIM" --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi

  # Install tree-sitter CLI for nvim-treesitter (requires npm)
  if ! command -v tree-sitter &>/dev/null; then
    echo "==> Installing tree-sitter CLI..."
    npm install -g tree-sitter-cli@0.24.7
  fi

  # Install TPM for tmux (if not present)
  TPM_DIR="$HOME/.config/tmux/plugins/tpm"
  if [ ! -d "$TPM_DIR" ]; then
    echo "==> Installing TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
  fi

  echo "==> Done installing packages."
}

do_stow() {
  echo "==> Deploying dotfiles with stow..."
  cd "$DOTFILES_DIR"
  for pkg in "${STOW_PACKAGES[@]}"; do
    if [ -d "$pkg" ]; then
      echo "  stow $pkg"
      stow -v -t "$HOME" "$pkg"
    fi
  done
  echo "==> Done."
}

do_unstow() {
  echo "==> Removing dotfile symlinks..."
  cd "$DOTFILES_DIR"
  for pkg in "${STOW_PACKAGES[@]}"; do
    if [ -d "$pkg" ]; then
      echo "  unstow $pkg"
      stow -v -D -t "$HOME" "$pkg"
    fi
  done
  echo "==> Done."
}

case "${1:-}" in
  install)  do_install ;;
  stow)     do_stow ;;
  unstow)   do_unstow ;;
  all)      do_install; do_stow ;;
  *)        usage; exit 1 ;;
esac
