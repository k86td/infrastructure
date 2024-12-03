{
  description = "B2B2C Host Management Flake";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    disko.url = "github:nix-community/disko/v1.9.0";
  };

  outputs = { self, nixpkgs-stable, disko }:
  {

    nixosConfigurations.netbox = import ./hosts/netbox/system.nix {
      pkgs = nixpkgs-stable;
    };

    # nixosConfiguration.mediawiki = import ./hosts/mediawiki/system.nix;

  };
}
