# My Linux Dotfiles

Personal dotfiles for Ubuntu, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Packages

| Package  | Contents                                          |
|----------|---------------------------------------------------|
| `bash`   | `.bashrc` — shell config, git prompt, aliases     |
| `tmux`   | tmux config — prefix `C-a`, vim-tmux-navigator     |
| `nvim`   | Neovim config with coc.nvim, fzf, NERDTree        |
| `i3`     | i3wm config, i3blocks, fuzzy lock, wallpapers     |
| `ranger` | File manager with autojump plugin                  |
| `docker` | Docker proxy config                                |
| `npm`    | `.npmrc` — npm registry and prefix                 |
| `pip`    | pip config                                         |
| `gtk`    | GTK 3 theme settings                               |
| `ghostty`| Ghostty terminal emulator config                   |

## Quick Start

```bash
# Install system packages
./install.sh install

# Deploy all dotfiles
./install.sh stow

# Or do both at once
./install.sh all
```

## Deploy Individual Packages

```bash
# Deploy a single package
stow -v -t $HOME nvim

# Remove a single package
stow -v -D -t $HOME nvim
```

## Dependencies

- [agentic-metric](https://github.com/MrQianjinsi/agentic-metric) — AI coding agent 指标监控，用于 i3blocks 和 tmux 状态栏显示今日 AI 用量。安装：`pip install agentic-metric`

## Fonts

Ghostty 使用 [JetBrains Mono Nerd Font Mono](https://github.com/ryanoasis/nerd-fonts/releases) 作为主字体，需额外安装 `fonts-symbola` 作为 fallback 以支持特殊 Unicode 符号（如 `⏵`）。

```bash
# JetBrains Mono Nerd Font
wget -P /tmp https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
mkdir -p ~/.local/share/fonts
tar -xf /tmp/JetBrainsMono.tar.xz -C ~/.local/share/fonts
fc-cache -f

# Symbola (Unicode symbol fallback)
sudo apt install -y fonts-symbola
```

## Machine-Specific Config

Some settings may need manual adjustment per machine:

- **i3/local.conf** — 显示器别名、xrandr 布局绑定、机器特定的应用分配和自启动程序。参考 `i3/.config/i3/local.conf.example` 创建 `~/.config/i3/local.conf`
- **i3blocks** — 配置中默认使用 `/usr/share/i3blocks/` 路径。如果你的机器上脚本在 `/usr/lib/i3blocks/`，创建符号链接使其兼容：
  ```bash
  sudo ln -s /usr/lib/i3blocks /usr/share/i3blocks
  ```
- **bashrc** — Run `conda init bash` if conda is needed

## 常见问题

### Ghostty SSH 到远程服务器后 Backspace 键表现为空格

Ghostty 默认设置 `TERM=xterm-ghostty`，但远程服务器上通常没有对应的 terminfo 条目，导致 Backspace 键的转义序列无法被正确解释。

解决方案 — 将 Ghostty 的 terminfo 同步到远程服务器：

```bash
infocmp -x | ssh 用户名@远程服务器 tic -x -
```

同步后重新连接即可。
