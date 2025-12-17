{
  cmake,
  fetchFromGitHub,
  lib,
  libgpg-error,
  libgcrypt,
  libusb1,
  stdenv,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "netmdplusplus";
  version = "unstable-2024-04-12";

  src = fetchFromGitHub {
    owner = "Jo2003";
    repo = "netmd_plusplus";
    rev = "2073b821d51afda046171e474e7864825e10088f";
    hash = "sha256-MO5qa+6BXtHx84YRZDjZvqOGjx74LJBiGx4qoe1IUyY=";
  };

  buildInputs = [
    libgcrypt
    libgpg-error
    libusb1
  ];

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    # https://github.com/NixOS/nixpkgs/issues/144170
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "C++ library for transferring audio to NetMD";
    license = lib.licenses.gpl3Plus;
    homepage = "https://github.com/Jo2003/netmd_plusplus";
    pkgConfigModules = [
      "libnetmd++"
    ];
    platforms = lib.platforms.all;
  };
})
