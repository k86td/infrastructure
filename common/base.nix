{ pkgs, config, ... }:
{
  imports = [
    ./groups.nix
    ./autoupdate.nix
  ];

  config = {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    time.timeZone = "America/Toronto";

  };
}
