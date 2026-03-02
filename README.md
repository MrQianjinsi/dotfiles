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

## Machine-Specific Config

Some settings may need manual adjustment per machine:

- **i3blocks.conf** — WiFi interface name (`instance=wlp0s20f3`)
- **i3/config** — Monitor names and resolutions (`$left`, `$middle`, `$right`)
- **bashrc** — Run `conda init bash` if conda is needed
