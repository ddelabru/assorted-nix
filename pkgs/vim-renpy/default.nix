{
  lib,
  vimUtils,
  fetchFromGitHub,
}:
vimUtils.buildVimPlugin {
  pname = "vim-renpy";
  version = "0-unstable-2015-02-26";

  src = fetchFromGitHub {
    owner = "chaimleib";
    repo = "vim-renpy";
    rev = "3434523ae70818573f5e24045547ea302eab4437";
    hash = "sha256-ZF8aQ7IxGV7Y2ssnvD+k+BKNhMumq8gUDEL/gZMGDEY=";
  };

  meta = {
    description = "Ren'Py script syntax highlighting for Vim";
    homepage = "https://github.com/chaimleib/vim-renpy";
    platforms = lib.platforms.all;
  };
}
