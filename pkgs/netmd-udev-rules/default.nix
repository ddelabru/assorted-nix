{
  lib,
  stdenv,
  fetchurl,
  nixosTests,
  udevCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "netmd-udev-rules";
  version = "unstable-2025-08-09";

  udevRules = fetchurl {
    url = "https://raw.githubusercontent.com/asivery/webminidisc/8cd3b3775fb918b77f585c5afbd1d9874cc888bf/extra/70-netmd.rules";
    sha256 = "sha256-qVUL08TFDau9pGuTVdL52GQii5qTmXih2bDOF7CXvWQ=";
  };

  nativeBuildInputs = [
    udevCheckHook
  ];

  doInstallCheck = true;

  dontUnpack = true;

  installPhase = ''
    cp ${udevRules} 70-netmd.rules
    mkdir -p $out/lib/udev/rules.d
    cp 70-netmd.rules $out/lib/udev/rules.d/70-netmd.rules
  '';

  meta = {
    description = "Udev rules for NetMD devices";
    platforms = lib.platforms.linux;
    homepage = "https://raw.githubusercontent.com/asivery/webminidisc/tree/master/extra";
  };
}