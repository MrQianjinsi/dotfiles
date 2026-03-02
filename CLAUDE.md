# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal Linux (Ubuntu 22.04) dotfiles repository managed with **GNU Stow**. Configurations for bash, tmux, neovim, i3 window manager, ranger, and related tools.

## Installation

- `install.sh` — Main script with subcommands: `install` (apt packages), `stow` (deploy), `unstow` (remove), `all` (install + stow)

## Repository Structure

The repo uses GNU Stow. Each top-level directory is a stow package that maps directly to `$HOME`. To add a new dotfile, place it under the appropriate package directory mirroring the home directory path.

Stow packages:

- `bash/.bashrc` — Shell config with git prompt (from `/usr/lib/git-core/git-sh-prompt`), CUDA paths, proxy aliases (`hp`/`unhp`)
- `tmux/.config/tmux/tmux.conf` — Prefix `C-a`, vim-tmux-navigator, TPM plugins (resurrect, continuum), Catppuccin status line
- `nvim/.config/nvim/init.vim` — Neovim with vim-plug. Leader `<Space>`. Plugins: coc.nvim (LSP), fzf.vim, NERDTree (`F5`), tagbar (`F6`), vim-tmux-navigator. Indentation: 2 spaces default, 4 for Python/C++
- `nvim/.config/nvim/coc-settings.json` — Language server configs (ccls, pylsp, vimls, cmake, dockerfile)
- `i3/.config/i3/config` — i3wm with `$mod=Mod4`, vim-style keys, 10 workspaces, multi-monitor, i3blocks, xautolock
- `i3/.config/i3/fuzzy_lock.sh` — Lock screen script (scrot + imagemagick pixelation + i3lock)
- `ranger/.config/ranger/` — File manager with autojump plugin
- `docker/.docker/config.json` — Docker proxy settings
- `npm/.npmrc` — npm registry (npmmirror.com) and global prefix
- `ghostty/.config/ghostty/config` — Ghostty terminal emulator settings
- `pip/.config/pip/pip.conf`, `gtk/.config/gtk-3.0/settings.ini` — Misc configs
