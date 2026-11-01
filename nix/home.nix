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
    version = "1.11.5";

    src = pkgs.fetchurl {
      url = "https://github.com/alibaba/open-code-review/releases/download/v1.11.5/opencodereview-darwin-arm64";
      hash = "sha256:c041b03cc840957b52df28514e8dbb51f798e6cb1259d97555a41a2e3e3ccaf9";
    };

    dontUnpack = true;

    installPhase = ''
      runHook preInstall
      install -Dm755 "$src" "$out/bin/ocr"
      runHook postInstall
    '';
  };

  opencode-cli = pkgs.stdenvNoCC.mkDerivation {
    pname = "opencode-cli";
    version = "1.18.29";

    src = pkgs.fetchurl {
      url = "https://github.com/anomalyco/opencode/releases/download/v1.18.29/opencode-darwin-arm64.zip";
      sha256 = "sha256-/nZPfzYMWEqD4Y3V8j+xprJyX17ohUsCUv5Vj3eY6UY=";
    };

    nativeBuildInputs = [ pkgs.unzip ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall
      install -Dm755 opencode "$out/bin/opencode"
      runHook postInstall
    '';
  };

  superseedr = pkgs.callPackage ./pkgs/superseedr.nix { };

  codebase-memory-mcp = pkgs.stdenvNoCC.mkDerivation {
    pname = "codebase-memory-mcp";
    version = "0.11.0";

    src = pkgs.fetchurl {
      url = "https://github.com/DeusData/codebase-memory-mcp/releases/download/v0.11.0/codebase-memory-mcp-darwin-arm64.tar.gz";
      hash = "sha256:4dee7f38b63740e6751d7a7ed7eb10291c1f2a3ea2415f599dc68370ca0a2d18";
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
    docker
    docker-compose
    docker-credential-helpers
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
    nodejs_24
    ollama
    opencode-cli
    open-code-review
    pandoc
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
    superseedr
    tcl
    terraform
    texinfo
    tlrc
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
