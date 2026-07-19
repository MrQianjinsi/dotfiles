# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='grep -F --color=auto'
    alias egrep='grep -E --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# colors!
green="\[\033[0;32m\]"
blue="\[\033[0;34m\]"
purple="\[\033[0;35m\]"
reset="\[\033[0m\]"

# git command prompt
source /usr/lib/git-core/git-sh-prompt
export GIT_PS1_SHOWDIRTYSTATE=1
# '\u' adds the name of the current user to the prompt
# '\$(__git_ps1)' adds git-related stuff
# '\W' adds the name of the current directory
export PS1="$purple\u$green\$(__git_ps1)$blue \W $ $reset"

# proxy environment
alias hp='export all_proxy=http://127.0.0.1:7890'
alias ccode="https_proxy='http://127.0.0.1:7890'  no_proxy='localhost,127.0.0.1' claude"
alias kiro="https_proxy='http://127.0.0.1:7890'  no_proxy='localhost,127.0.0.1' kiro-cli"
alias codex="https_proxy='http://127.0.0.1:7890'  no_proxy='localhost,127.0.0.1' codex"
alias codex-yolo="https_proxy='http://127.0.0.1:7890'  no_proxy='localhost,127.0.0.1' codex --dangerously-bypass-approvals-and-sandbox"
alias codex-yolo="https_proxy='http://127.0.0.1:7890'  no_proxy='localhost,127.0.0.1' codex --dangerously-bypass-approvals-and-sandbox"
alias ccode-yolo="https_proxy='http://127.0.0.1:7890'  no_proxy='localhost,127.0.0.1' claude --dangerously-skip-permissions"
alias ccode-remote="https_proxy='http://127.0.0.1:7890'  no_proxy='localhost,127.0.0.1' claude remote-control --dangerously-skip-permissions"
alias claude-yolo="claude --dangerously-skip-permissions"
alias unhp='unset all_proxy'
alias vim='nvim'
export EDITOR=vim

# Recover a live DISPLAY/XAUTHORITY when the inherited one is stale.
# Long-lived tmux panes can keep an old DISPLAY, which breaks X11 clipboard
# access and image paste in terminal apps.
_fix_x11_env_for_tmux() {
    command -v xset >/dev/null 2>&1 || return

    _x11_display_works() {
        [ -n "$1" ] || return 1

        case "$1" in
            :*|unix:*)
                _x11_num="${1#unix:}"
                _x11_num="${_x11_num%%.*}"
                _x11_num="${_x11_num#:}"
                [ -S "/tmp/.X11-unix/X$_x11_num" ] || return 1
                ;;
        esac

        if command -v timeout >/dev/null 2>&1; then
            DISPLAY="$1" XAUTHORITY="${2-${XAUTHORITY:-}}" timeout 1 xset q >/dev/null 2>&1
        else
            DISPLAY="$1" XAUTHORITY="${2-${XAUTHORITY:-}}" xset q >/dev/null 2>&1
        fi
    }

    if _x11_display_works "${DISPLAY:-}" "${XAUTHORITY:-}"; then
        unset -f _x11_display_works
        return
    fi

    if [ -n "${TMUX:-}" ] && command -v tmux >/dev/null 2>&1; then
        _tmux_display=$(tmux show-environment -g DISPLAY 2>/dev/null | sed -n 's/^DISPLAY=//p')
        _tmux_xauth=$(tmux show-environment -g XAUTHORITY 2>/dev/null | sed -n 's/^XAUTHORITY=//p')
        if _x11_display_works "$_tmux_display" "$_tmux_xauth"; then
            export DISPLAY="$_tmux_display"
            [ -n "$_tmux_xauth" ] && export XAUTHORITY="$_tmux_xauth"
        fi
    fi

    if ! _x11_display_works "${DISPLAY:-}" "${XAUTHORITY:-}"; then
        _xauth_from_xorg=$(ps -eo args= 2>/dev/null | sed -n 's/.*-auth \([^ ]*\).*/\1/p' | head -n 1)
        _xauth_candidates="${XAUTHORITY:-} $_xauth_from_xorg /run/user/$(id -u)/gdm/Xauthority $HOME/.Xauthority"

        for _xsock in /tmp/.X11-unix/X*; do
            [ -S "$_xsock" ] || continue
            _xdpy=":${_xsock##*/X}"

            for _xauth in $_xauth_candidates; do
                [ -n "$_xauth" ] || continue
                [ -r "$_xauth" ] || continue
                if _x11_display_works "$_xdpy" "$_xauth"; then
                    export DISPLAY="$_xdpy"
                    export XAUTHORITY="$_xauth"
                    break 2
                fi
            done

            if _x11_display_works "$_xdpy" ""; then
                export DISPLAY="$_xdpy"
                break
            fi
        done
    fi

    unset -f _x11_display_works
    unset _x11_num _tmux_display _tmux_xauth _xauth_from_xorg _xauth_candidates _xsock _xdpy _xauth
}
_fix_x11_env_for_tmux
unset -f _fix_x11_env_for_tmux

# Push the current GUI session environment back into tmux so new panes inherit
# the right X11/desktop clipboard settings after attach or display changes.
if [ -n "${TMUX:-}" ] && command -v tmux >/dev/null 2>&1; then
    for _tmux_env_var in DISPLAY XAUTHORITY DBUS_SESSION_BUS_ADDRESS XDG_SESSION_TYPE WAYLAND_DISPLAY XDG_CURRENT_DESKTOP DESKTOP_SESSION; do
        if [ -n "${!_tmux_env_var:-}" ]; then
            tmux set-environment -g "$_tmux_env_var" "${!_tmux_env_var}" >/dev/null 2>&1
        fi
    done
    unset _tmux_env_var
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$("$HOME/miniconda3/bin/conda" 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
