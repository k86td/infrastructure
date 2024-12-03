{
  description = "B2B2C Host Management Flake";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs-stable }:
  {

    nixosConfigurations.netbox = import ./hosts/netbox/system.nix {
      pkgs = nixpkgs-stable;
    };

    # nixosConfiguration.mediawiki = import ./hosts/mediawiki/system.nix;

  };
}
