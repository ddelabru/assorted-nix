{ autoPatchelfHook
, p7zip
, pkgsi686Linux
, requireFile
}:
pkgsi686Linux.stdenv.mkDerivation {
  pname = "at3tool";
  version = "3.0.0.0";
  src = requireFile {
    name = "psp_sdk_660.7z";
    hash = "sha256-PCDoO4A/FqlZ9uTcL0uoRMVgk2EJx+n1beyIRiV7a9Y=";
    message = ''
      The psp_sdk_660.7z archive file must be in the Nix store before this
      derivation can be built. Add the file to the Nix store like this:

        # from a directory where the file is already downloaded:
        nix-store --add-fixed sha256 psp_sdk_660.7z
        # or, using a remote url:
        nix-prefetch-url --type sha256 "https://example.com/psp_sdk_660.7z"
    '';
  };
  sourceRoot = "usr/local/psp/devkit/tool/at3tool/linux";
  nativeBuildInputs = [ autoPatchelfHook p7zip ];
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/lib
    install -Dm 755 at3tool $out/bin/at3tool
    install -Dm 755 libatrac.so.1.2.0 $out/lib/libatrac.so.1.2.0
    ln -rsT $out/lib/libatrac.so.1.2.0 $out/lib/libatrac.so.1

    runHook postInstall
  '';
}

