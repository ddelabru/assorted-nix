{
  cmake,
  fetchFromGitHub,
  lib,
  libsndfile,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "atracdenc";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "dcherednik";
    repo = "atracdenc";
    tag = "${finalAttrs.version}";
    hash = "sha256-YixLz0pX4xPuy+HsKQraJdRpBfNL/SyDtEr4HEBouSY=";
    fetchSubmodules = true;
  };

  buildInputs = [
    libsndfile
  ];

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "ATRAC decoder/encoder";
    license = lib.licenses.lgpl21Plus;
    homepage = "https://github.com/dcherednik/atracdenc";
    mainProgram = "atracdenc";
    platforms = lib.platforms.all;
  };
})