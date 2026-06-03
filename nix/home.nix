{ pkgs, inputs, ... }:

{
  home.username = "harshsharma";
  home.homeDirectory = "/Users/harshsharma";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    abduco
    aria2
    autoconf
    awscli2
    aerospace
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
    go
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
    regal
    resvg
    ripgrep
    ruff
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
    inputs."hermes-agent".packages.${pkgs.system}.default
    dbeaver-bin
    ghostty-bin
    google-cloud-sdk
    karabiner-elements
    keycastr
    neovim
    http-server
    libjpeg
    monitorcontrol
    ngrok
    openscreen
    pinentry_mac
    switchaudio-osx
    sketchybar

    nerd-fonts._0xproto
    nerd-fonts._3270
    nerd-fonts.adwaita-mono
    nerd-fonts.agave
    nerd-fonts.anonymice
    nerd-fonts.arimo
    nerd-fonts.atkynson-mono
    nerd-fonts.aurulent-sans-mono
    nerd-fonts.bigblue-terminal
    nerd-fonts.bitstream-vera-sans-mono
    nerd-fonts.blex-mono
    nerd-fonts.caskaydia-cove
    nerd-fonts.caskaydia-mono
    nerd-fonts.code-new-roman
    nerd-fonts.comic-shanns-mono
    nerd-fonts.commit-mono
    nerd-fonts.cousine
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
    nerd-fonts.monaspace
    nerd-fonts.symbols-only
    noto-fonts

    (writeShellScriptBin "doom" ''
      exec "$HOME/.emacs.d/bin/doom" "$@"
    '')
  ];
}
