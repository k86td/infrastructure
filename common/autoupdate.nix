{ config, pkgs, lib, ... }:
let
  cfg = config.services.autoUpdateFlake;
in
{
  options = {
    services.autoUpdateFlake = {
      enable = lib.mkEnableOption "Create a timer to automatically update system using a flake";
      flakePath = lib.mkOption {
        type = lib.types.path;
        default = /etc/nixos;
        description = "The path where the flake is saved";
      };
      flakeTarget = lib.mkOption {
        type = lib.types.str;
        description = "The target to be used in the flake (<path>#<target>)";
      };
      interval = lib.mkOption {
        type = lib.types.str;
        default = "5m";
        description = "The interval of the update";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # configure auto-update flake timers
    systemd.timers."update-flake" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        Unit = "update-flake.service";
        OnUnitActiveSec = "${cfg.interval}";
      };
    };

    systemd.services."update-flake" = {
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };

      script = ''
        set -eu
        pushd ${cfg.flakePath}

        export PATH=${pkgs.git}/bin:$PATH

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
          /run/current-system/sw/bin/nixos-rebuild switch --flake ${cfg.flakePath}#${cfg.flakeTarget}
        else
          ${pkgs.coreutils}/bin/echo "up to date."
        fi
        popd
      '';
    };
  };
}
