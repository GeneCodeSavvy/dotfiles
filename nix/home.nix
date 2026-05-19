{ pkgs, ... }:

{
  home.username = "harshsharma";
  home.homeDirectory = "/Users/harshsharma";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry_mac;
    defaultCacheTtl = 86400;
    maxCacheTtl = 86400;
  };

  home.packages = with pkgs; [
    aria2
    autoconf
    awscli2
    bash
    bat
    bc
    cmake
    coreutils
    coursier
    curl
    dotenvx
    eget
    entr
    eza
    fastfetch
    fd
    fzf
    gh
    git
    git-filter-repo
    git-lfs
    glab
    gnupg
    gnuplot
    graphviz
    htop
    hunspell
    jq
    lazydocker
    lazygit
    libgccjit
    luarocks
    mongosh
    mutagen
    ninja
    nodejs_22
    ollama
    opencode
    pandoc
    pipx
    pngpaste
    pnpm
    poppler
    protobuf
    python313
    redis
    resvg
    rustup
    p7zip
    starship
    tcl
    texinfo
    tlrc
    tmux
    tree
    tree-sitter
    unar
    uv
    wget
    yazi
    zlib
    zoxide

    claude-code
    codex
    emacs
    gawk
    gnugrep
    gnumake
    neovim
    http-server
    libjpeg
    pinentry_mac
    switchaudio-osx

    sketchybar

    (writeShellScriptBin "cliclick" ''
      exec /opt/homebrew/bin/cliclick "$@"
    '')
    (writeShellScriptBin "mac-brightnessctl" ''
      exec /opt/homebrew/bin/mac-brightnessctl "$@"
    '')
    (writeShellScriptBin "doom" ''
      exec "$HOME/.emacs.d/bin/doom" "$@"
    '')
  ];

  # Managed by nix-darwin Homebrew because they are not present in this
  # pinned nixpkgs set:
  # - cliclick
  # - rakalex/mac-brightnessctl/mac-brightnessctl
}
