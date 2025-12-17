# This custom Nix derivation of Ren'Py utilizes Steam to provide the Filesystem
# Hierarchy Standard (FHS) which is otherwise not present on NixOS, allowing
# Ren'Py to make distributions of games. Instead of running Ren'Py from the Nix
# store, it copies the Ren'Py SDK into ~/.local/share/renpy on the first run so
# that Ren'Py can modify itself, allowing for tasks like installing the Android
# SDK or self-updating Ren'Py.

{
  copyDesktopItems,
  fetchzip,
  imagemagick,
  jdk25_headless,
  lib,
  libicns,
  makeDesktopItem,
  makeWrapper,
  stdenv,
  steam-run,
}:
let
  pname = "renpy";
  version = "8.5.0";
  rapt-src = fetchzip {
    url = "https://www.renpy.org/dl/${version}/renpy-${version}-rapt.zip";
    hash = "sha256-wuy/Nk5R+6GSHKw8ITbjaVmVO4NIARAC4Nm/IV9bByk=";
  };
  meta = {
    description = "Visual novel engine";
    homepage = "https://renpy.org";
    changelog = "https://renpy.org/doc/html/changelog.html";
    license = lib.licenses.mit;
    mainProgram = "renpy";
    platforms = [
      "x86_64-linux"
    ];
  };
  renpy-desktop-item = makeDesktopItem {
    type = "Application";
    name = pname;
    desktopName = "Ren'Py";
    genericName = "Visual novel engine";
    comment = "Develop visual novels that run on pygame";
    exec = "renpy";
    icon = "renpy";
    categories = [
      "Development"
    ];
  };
in
stdenv.mkDerivation {
  name = "renpy";
  src = fetchzip {
    url = "https://www.renpy.org/dl/${version}/renpy-${version}-sdk.tar.bz2";
    hash = "sha256-w8+p6enjaJllfyHBGMGHEDYq2qRrNJvJ6HY1ZNIWKlk=";
  };
  buildInputs = [
    jdk25_headless
    steam-run
  ];
  nativeBuildInputs = [
    copyDesktopItems
    imagemagick
    libicns
    makeWrapper
  ];
  buildPhase = "";
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/renpy/rapt
    cp -pR ./* $out/share/renpy/
    cp -pR ${rapt-src}/* $out/share/renpy/rapt/

    # Extract pngs from the Apple icon image and create
    # the missing ones from the 1024x1024 image.
    icns2png --extract launcher/icon.icns
    for size in 16 24 32 48 64 128 256 512 1024; do
      mkdir -pv $out/share/icons/hicolor/"$size"x"$size"/apps
      if [ ! -e icon_"$size"x"$size"x32.png ] ; then
        magick icon_1024x1024x32.png -resize "$size"x"$size" icon_"$size"x"$size"x32.png
      fi
      install -Dm644 icon_"$size"x"$size"x32.png $out/share/icons/hicolor/"$size"x"$size"/apps/renpy.png
    done;

    echo '#!/bin/bash
    if ! stat "$HOME"/.local/share/renpy &> /dev/null
    then
      mkdir -p "$HOME"/.local/share
      cp -R '$out'/share/renpy "$HOME"/.local/share/renpy
      chmod -R u+w "$HOME"/.local/share/renpy
    fi
    ${lib.getExe steam-run} "$HOME"/.local/share/renpy/renpy.sh "$@"
    ' > launch-renpy.sh

    mkdir -p $out/bin
    install -Dm755 launch-renpy.sh $out/bin/renpy
    wrapProgram $out/bin/renpy \
      --suffix PATH : ${lib.makeBinPath [ jdk25_headless ]}

    runHook postInstall
  '';
  desktopItems = [ renpy-desktop-item ];
  inherit meta;
}
