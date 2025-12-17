{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
  };
  outputs = {
    self,
    flake-utils,
    nixpkgs,
  }: {
    overlays.default = import ./pkgs/overlay.nix;
    # packages = {
      # cd2netmd-gui = nixpkgs.callPackage ./pkgs/cd2netmd-gui;
      # i686-linux.at3tool = nixpkgs.legacyPackages.i686-linux.callPackage ./pkgs/at3tool { };
    # };
  }
  // flake-utils.lib.eachDefaultSystem (
    system:
    let
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowAliases = false;
        allowUnfree = true;  # for steam-run, used to wrap Ren'Py
      };
      overlays = [ self.overlays.default ];
    };
    in
    {
      packages = {
        at3tool = pkgs.at3tool;
        cd2netmd-gui = pkgs.cd2netmd-gui;
        netmd-udev-rules = pkgs.netmd-udev-rules;
        renpy = pkgs.renpy;
    };
    }
  );
}

