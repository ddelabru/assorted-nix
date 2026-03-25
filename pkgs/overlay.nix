final: prev: {
  at3tool = prev.callPackage ./at3tool { };
  atracdenc = prev.callPackage ./atracdenc { };
  cd2netmd-gui = prev.callPackage ./cd2netmd-gui { };
  ersatz-jjy = prev.callPackage ./ersatz-jjy { };
  jawanndenn = final.callPackage ./jawanndenn { };
  jawanndenn-frontend = prev.callPackage ./jawanndenn-frontend { };
  netmd-udev-rules = prev.callPackage ./netmd-udev-rules { };
  netmdplusplus = prev.callPackage ./netmdplusplus { };
  python3 = prev.python3 // {
    pkgs = prev.python3.pkgs // {
      gunicorn_color = prev.python3.pkgs.callPackage ./gunicorn-color { };
    };
  };
  renpy = prev.callPackage ./renpy { };
  vim-renpy = prev.callPackage ./vim-renpy { };
}
