# Homebrew
if [[ -x "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  brew_prefix=$(/opt/homebrew/bin/brew --prefix)
else
  brew_prefix=""
fi

# SDKMAN
export SDKMAN_DIR="${HOME}/.sdkman"
[[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/harshsharma/Desktop/100xdevs/s30/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/harshsharma/Desktop/100xdevs/s30/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/harshsharma/Desktop/100xdevs/s30/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/harshsharma/Desktop/100xdevs/s30/google-cloud-sdk/completion.zsh.inc'; fi

# bun completions
[ -s "/Users/harshsharma/.bun/_bun" ] && source "/Users/harshsharma/.bun/_bun"

. "/Users/harshsharma/.deno/env"

export PATH=:$PATH

# pipx (2025-02-18) and Cargo
. "$HOME/.cargo/env"

typeset -U -a path
path=(
  "$HOME/.local/bin"

  # Go tools
  "$HOME/go/bin"

  # Doom Emacs
  "$HOME/.emacs.d/bin"

  # Bun 
  "$HOME/.bun/bin"

  # Coursier
  "$HOME/Library/Application Support/Coursier/bin"

  # Antigravity
  "$HOME/.antigravity/antigravity/bin"

  # Preserve whatever was already in PATH
  $path
)

# Finally export
export PATH
export GPG_TTY=$(tty) 
