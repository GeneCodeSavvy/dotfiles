remaining_days() {
    local CUSTOM_DATE=$1

    # === Calculation Logic ===
    local TODAY=$(date +%s)
    local TARGET=$(date -j -f "%Y-%m-%d" "$CUSTOM_DATE" +%s)
    local SECONDS_REMAINING=$(( TARGET - TODAY ))
    local DAYS_REMAINING=$(( SECONDS_REMAINING / 86400 ))
    local PRETTY_DATE=$(date -j -f "%Y-%m-%d" "$CUSTOM_DATE" +"%A, %B %d, %Y")
    
    if (( DAYS_REMAINING < 0 )); then DAYS_REMAINING=0; fi

    # === Color & Style Definitions ===
    # These use Hex codes for that precise "Lotus/Terracotta" look
    local GOLD='\e[38;2;233;196;106m'
    local SAGE='\e[38;2;138;154;91m'
    local LOTUS='\e[3;38;2;209;73;91m' # The '3' triggers the Handwriting Italics
    local RESET='\e[0m'
    local DIM='\e[2;38;2;234;216;192m'

    # === The Output ===
    echo "" # Leading breath
    # Quote Section (Handwritten Style)
    printf "${LOTUS}  \"Real Men, produce more than they consume.\"${RESET}\n"
    printf "${LOTUS}  Let's get to work. All the best.${RESET}\n"
    
    echo "" # Spacing

    # Data Section (Architectural Style)
    printf "  ${GOLD}${DAYS_REMAINING}${RESET} ${DIM}days remaining until${RESET}\n"
    printf "  ${SAGE}❯ ${PRETTY_DATE}${RESET}\n"
    echo ""
}

# Execution
clear
fastfetch
remaining_days "2026-05-15"


# Set the directory to store Zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit if it's not already present
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load Zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add Zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Load completions
autoload -Uz compinit && compinit

# Replay commands in a quiet mode
zinit cdreplay -q

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '\ew' backward-kill-line

# History settings
HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTFILE="${HOME}/.config/zsh/.zsh_history"
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Aliases
alias ls='eza'
alias l='eza -la'
alias c='clear'
alias org='cd org && emacs &'
alias vi='nvim'
alias oc='opencode'
alias lz='lazygit'
alias ff='fastfetch'
alias resume='mv ~/Downloads/Resume.pdf ~/Documents/Resume\ Certificates/resume_harsh.pdf && rsync -avz --rsync-path="sudo rsync" ~/Documents/Resume\ Certificates/resume_harsh.pdf oracle-vm:/srv/'

# Add snippets
zinit snippet OMZP::git

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Shell integrations
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"  # Starship
command -v fzf >/dev/null 2>&1 && eval "$(fzf --zsh)"          # fzf
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init --cmd cd zsh)"  # Zoxide


function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

ad() {
    local tmpd="$PWD"
    cd ~/Desktop/100xdevs/work/auth/ || return
    pnpm docker:down
    cd "$tmpd" || return
}

au() {
    local tmpd="$PWD"
    cd ~/Desktop/100xdevs/work/auth/ || return
    pnpm docker:up
    cd "$tmpd" || return
}

adb() {
    local tmpd="$PWD"
    printf "%s\n" "$tmpd"
    cd ~/Desktop/100xdevs/work/auth/ || return
    pnpm db:up
    cd "$tmpd" || return
}

adbd() {
    local tmpd="$PWD"
    cd ~/Desktop/100xdevs/work/auth/ || return
    pnpm db:down
    cd "$tmpd" || return
}

export GOPATH="$HOME/deeper-love-for-go"
