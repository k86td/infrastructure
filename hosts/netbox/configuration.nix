# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }@inputs:

{
  imports =
    [
      inputs.disko
      ./hardware-configuration.nix
    ];

  networking.hostName = "netbox";

  groups.sysadmin.enable = true;
  groups.niveau3.enable = true;

  system.stateVersion = "25.05"; # Did you read the comment?

}

