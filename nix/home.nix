{ pkgs, ... }:

let
  grok-cli = pkgs.stdenvNoCC.mkDerivation {
    pname = "grok-cli";
    version = "0.2.93";

    src = pkgs.fetchurl {
      url = "https://x.ai/cli/grok-0.2.93-macos-aarch64";
      hash = "sha256-Kpe6Z1vZkqqbmB4ug3dkYNlPRptRDAuO/ii1DSNtdnw=";
    };

    dontUnpack = true;

    installPhase = ''
      runHook preInstall
      install -Dm755 "$src" "$out/bin/grok"
      ln -s grok "$out/bin/agent"
      runHook postInstall
    '';
  };

  open-code-review = pkgs.stdenvNoCC.mkDerivation {
    pname = "open-code-review";
    version = "1.6.6";

    src = pkgs.fetchurl {
      url = "https://github.com/alibaba/open-code-review/releases/download/v1.6.6/opencodereview-darwin-arm64";
      hash = "sha256-rCcewegYHsr803A3sQTVMNOwS6JYVGP4JHwjaVNOCNA=";
    };

    dontUnpack = true;

    installPhase = ''
      runHook preInstall
      install -Dm755 "$src" "$out/bin/ocr"
      runHook postInstall
    '';
  };

  codebase-memory-mcp = pkgs.stdenvNoCC.mkDerivation {
    pname = "codebase-memory-mcp";
    version = "0.8.1";

    src = pkgs.fetchurl {
      url = "https://github.com/DeusData/codebase-memory-mcp/releases/download/v0.8.1/codebase-memory-mcp-darwin-arm64.tar.gz";
      hash = "sha256-+9BHUJhSAhtURqERQbywo9Hcrr9uURJGCWDynwUsHFg=";
    };

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall
      install -Dm755 codebase-memory-mcp "$out/bin/codebase-memory-mcp"
      install -Dm644 LICENSE "$out/share/doc/codebase-memory-mcp/LICENSE"
      install -Dm644 THIRD_PARTY_NOTICES.md "$out/share/doc/codebase-memory-mcp/THIRD_PARTY_NOTICES.md"
      runHook postInstall
    '';
  };
in
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
    docker-compose
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
    grok-cli
    graphviz
    htop
    hunspell
    python3Packages.huggingface-hub
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
    open-code-review
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

    codex
    codebase-memory-mcp
    emacs
    gawk
    gnugrep
    gnumake
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

  services.colima.enable = true;
}
