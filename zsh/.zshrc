# Auto-extracted interactive-shell settings from original .zshrc
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

    # Today’s date
    local today_date=$(date +"%A, %B %d, %Y")

    # Determine next March 1
    local current_year=$(date +%Y)
    local month_day=$(date +"%m-%d")
    local target_year=$current_year
    if [[ "$month_day" > "03-01" ]]; then
      target_year=2025
    fi
    local target_date="${target_year}-10-01"

    # Seconds since epoch
    local now_s=$(date +%s)
    local target_s=$(date -jf "%Y-%m-%d" "${target_date}" +%s)

    # Days left
    local days_left=$(( (target_s - now_s) / 86400 ))

    # Uptime (e.g. “3 days, 5:22”)
    local uptime_info=$(uptime | sed -E 's/.*up ([^,]+), .*/\1/')

    # Load averages
    local load_avg=$(uptime | awk -F'load averages?: ' '{print $2}')

    # Memory usage via top
    # PhysMem: 8G used (2G wired), 2G unused
    local mem_usage=$(top -l 1 | awk '/PhysMem/ {print $2 " used, " $6 " free"}')

    # Disk usage on /
    local disk_usage=$(df -h / | awk 'NR==2 {print $3 " / " $2}')

    # Logged‑in users
    local users_logged=$(who | wc -l)

    # Print it all
    printf "\n${blue}${bold}Welcome to your terminal,${reset} ${red}${underline}Harsh${reset}\n\n"

    printf "${blue}Today is ${yellow}${today_date}${reset}${magenta}.${reset}\n\n"

    printf "${blue}${bold}Countdown to November 1, ${target_year}:${reset} ${cyan}${bold}${days_left} days${reset}\n\n"

    printf "${green}${bold}System Status:${reset}\n"
    printf "  ${cyan}Uptime:     ${reset}${uptime_info}\n"
    printf "  ${cyan}Load Avg:   ${reset}${load_avg}\n"
    printf "  ${cyan}Memory:     ${reset}${mem_usage}\n"
    printf "  ${cyan}Disk (/):   ${reset}${disk_usage}\n"
    printf "  ${cyan}Users:      ${reset}${users_logged}\n\n"

    # Motivational quote
    local quote="Change happens every day. Strive for what you desire, every day."
    printf "${magenta}${bold}\"${quote}\"${reset}\n\n"

    printf "${red}${bold}Let's get to work—good luck!${reset}\n\n"
}


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
alias c='clear'
alias notes='cd ~/notes/ && NVIM_APPNAME=notesvim nvim'
alias gsoc='cd ~/notes/projects/gsoc/ && NVIM_APPNAME=notesvim nvim'
alias blog='cd ~/notes/projects/portfolio/ && NVIM_APPNAME=notesvim nvim'
alias dev='cd ~/notes/development/ && NVIM_APPNAME=notesvim nvim'
alias skim='/Applications/Skim.app/Contents/MacOS/Skim'

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
