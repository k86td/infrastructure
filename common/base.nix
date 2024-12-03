{ pkgs, config, ... }:
{
  imports = [
    ./groups.nix
  ];

  config = {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    time.timeZone = "America/Toronto";

    environment.systemPackages = [
      pkgs.git
    ];

    # configure auto-update flake timers
    systemd.timers."update-flake" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        Unit = "update-flake.service";
        OnUnitActiveSec = "1m";
      };
    };

    systemd.services."update-flake" = {
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
      script = ''
        set -eu
        pushd /etc/nixos
        ${pkgs.git}/bin/git fetch

        current_branch=$(${pkgs.git}/bin/git rev-parse --abbrev-ref HEAD)
        upstream_branch="origin/$current_branch"

        if ! ${pkgs.git}/bin/git rev-parse --verify "$upstream_branch" &> /dev/null; then
          ${pkgs.coreutils}/bin/echo "no upstream breanch for $current_branch"
          exit 1
        fi

        local_commit=$(${pkgs.git}/bin/git rev-parse "$current_branch")
        remote_commit=$(${pkgs.git}/bin/git rev-parse "$upstream_branch")

        if [ "$local_commit" != "$remote_commit" ]; then
          ${pkgs.coreutils}/bin/echo "found upstream changes. updating..."
          ${pkgs.git}/bin/git pull
          /run/current-system/sw/bin/nixos-rebuild switch --flake /etc/nixos#netbox
        else
          ${pkgs.coreutils}/bin/echo "up to date."
        fi
        popd
      '';
    };
  };
}
