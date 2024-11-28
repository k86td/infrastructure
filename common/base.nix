{ pkgs, config, ... }:
{
  imports = [
    ./groups.nix
  ];

  config = {
    time.timeZone = "America/Toronto";
  };
}
