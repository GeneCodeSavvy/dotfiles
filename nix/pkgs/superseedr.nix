{
  lib,
  stdenvNoCC,
  fetchurl,
  xar,
  cpio,
  gzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "superseedr";
  version = "1.0.16";

  src = fetchurl {
    url = "https://github.com/Jagalite/superseedr/releases/download/v${finalAttrs.version}/superseedr-v${finalAttrs.version}-universal-macos.pkg";
    hash = "sha256-DB9Mfj5ORCNOmtpykWofvsVeztotkFhqpeuq/QtRkZU=";
  };

  nativeBuildInputs = [
    xar
    cpio
    gzip
  ];

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    xar -xf "$src"
    gzip -dc Payload | cpio -id
    install -Dm755 usr/local/bin/superseedr "$out/bin/superseedr"
    mkdir -p "$out/Applications"
    cp -R Applications/superseedr.app "$out/Applications/"
    runHook postInstall
  '';

  meta = {
    description = "BitTorrent client in your terminal";
    homepage = "https://github.com/Jagalite/superseedr";
    license = lib.licenses.gpl3Plus;
    mainProgram = "superseedr";
    platforms = lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
