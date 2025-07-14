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

# pipx (2025-02-18) and Cargo
. "$HOME/.cargo/env"

typeset -U -a path
path=(
  "$HOME/.local/bin"

  # Go tools
  "$HOME/go/bin"

  "$HOME/.config/emacs/bin"

  # Preserve whatever was already in PATH
  $path
)

# Finally export
export PATH
