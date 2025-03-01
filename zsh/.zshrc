# export PATH="/usr/local/opt/tcl-tk/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Custom welcome message function for macOS
welcome_message() {
    # Define colors using ANSI escape codes
	local black='\033[30m'
	local red='\033[31m'
	local green='\033[32m'
	local yellow='\033[33m'
	local blue='\033[34m'
	local magenta='\033[35m'
	local cyan='\033[36m'
	local white='\033[37m'
	local reset='\033[0m'
    local bold='\033[1m'
    local underline='\033[4m'

    # Get today's date in a readable format
    local today_date=$(date +"%A, %B %d, %Y")
    
    # Set the target date to 1 March 2025
    local target_date="2025-03-01"
    
    # Calculate days remaining until 1 March 2025
    local days_left_year=$(( ( $(date -jf "%Y-%m-%d" "${target_date}" +%s) - $(date +%s) ) / 86400 ))

    # Calculate days left in the month (relative to February 2025)
    local days_in_month=$(cal 2 2025 | awk 'NF {DAYS = $NF}; END {print DAYS}')
    local current_day_of_month=$(date +%d)
    local days_left_month=$((days_in_month - current_day_of_month))

    # Calculate days left in the week
    local day_of_week=$(date +%u)
    local days_left_week=$((7 - day_of_week))

    # Calculate hours remaining in the day
    local current_hour=$(date +%H)
    local hours_left_day=$((24 - current_hour))
	
    # Print the styled welcome message beside the ASCII art
    printf "\n${blue}${bold}Welcome to the terminal,${reset} ${red}${underline}Harsh${reset}\n"
    printf "${blue}Today is ${yellow}${today_date}${reset}${magenta}.${reset}\n\n"
    printf "${blue}${bold}Countdown till March 2025:${reset}\n"
    printf "${blue}\u2022 Year:${reset} ${cyan} ${bold}${days_left_year} days${reset}\n"
    printf "${blue}\u2022 Month:${reset} ${cyan} ${bold}${days_left_month} days${reset}\n"
    printf "${blue}\u2022 Week:${reset} ${cyan} ${bold}${days_left_week} days${reset}\n"
    printf "${blue}\u2022 Day:${reset} ${cyan} ${bold}${hours_left_day} hours${reset}\n\n"
    printf "${red}${bold}Let's get to work, Good luck!${reset}\n\n"
}


if [[ -f "/opt/homebrew/bin/brew" ]]; then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi


# Call the function on each new session
welcome_message


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
HISTFILE="${HOME}/.zsh_history"
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Aliases
alias ls='ls --color=auto'
alias vim='nvim'
alias c='clear'

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


# SDKMAN integration
export SDKMAN_DIR="${HOME}/.sdkman"
if [ -s "${HOME}/.sdkman/bin/sdkman-init.sh" ]; then
    source "${HOME}/.sdkman/bin/sdkman-init.sh"
fi

# Created by `pipx` on 2025-02-18 05:43:47
export PATH="$PATH:/Users/harshsharma/.local/bin"
. "$HOME/.cargo/env"
