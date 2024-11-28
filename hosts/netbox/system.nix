{ pkgs, ... }:
pkgs.lib.nixosSystem {
  system = "x86_64-linux";

  modules = [{
    imports = [
      ../../common/base.nix
      ./configuration.nix
    ];
  }];
}
