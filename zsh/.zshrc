remaining_days() {
    local CUSTOM_DATE=$1

    # === Calculate days remaining ===
    local TODAY=$(date +%s)
    local TARGET=$(date -j -f "%Y-%m-%d" "$CUSTOM_DATE" +%s)
    local SECONDS_REMAINING=$(( TARGET - TODAY ))
    local DAYS_REMAINING=$(( SECONDS_REMAINING / 86400 ))
    local PRETTY_DATE=$(date -j -f "%Y-%m-%d" "$CUSTOM_DATE" +"%A, %B %d, %Y")
    
    # Don't allow negative days
    if (( DAYS_REMAINING < 0 )); then
        DAYS_REMAINING=0
    fi

    # === Escape the injected text properly ===
    local MESSAGE="\t$DAYS_REMAINING days --> '$PRETTY_DATE'"

    # ANSI color/style codes
    ITALIC_RED='\e[1;3;91m'
    RESET='\e[0m'

    # Use the variables in the printf statements
    printf "${ITALIC_RED}\tReal Men, produce more than they consume.\n\tLet's get to work. All the best.\n${RESET}\n"
    printf "${ITALIC_RED}${MESSAGE}${RESET}\n"

}

fastfetch
remaining_days "2026-2-20"


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

# Add snippets
zinit snippet OMZP::git

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Load nvm
if [ -f "${HOME}/.nvm/nvm.sh" ]; then
    source "${HOME}/.nvm/nvm.sh"
fi

# Shell integrations
eval "$(starship init zsh)"  # Starship
eval "$(fzf --zsh)"          # fzf
eval "$(zoxide init --cmd cd zsh)"  # Zoxide


function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/harshsharma/Desktop/100xdevs/s30/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/harshsharma/Desktop/100xdevs/s30/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/harshsharma/Desktop/100xdevs/s30/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/harshsharma/Desktop/100xdevs/s30/google-cloud-sdk/completion.zsh.inc'; fi
