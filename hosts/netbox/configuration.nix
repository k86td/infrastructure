# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
let
  netboxSecretPath = "/var/lib/netbox/secret";
  testIP = "192.168.56.50";
in {
  imports =
    [
      ./hardware-configuration.nix
    ];

  networking.hostName = "netbox";
  networking.fqdn = "b2b2c.net";

  networking.interfaces.enp0s8.ipv4.addresses = [ { address = "192.168.56.50"; prefixLength = 24; } ];
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 80 443 ];
  };

  groups.sysadmin.enable = true;
  groups.niveau3.enable = false;

  system.stateVersion = "25.05"; # Did you read the comment?

  services.autoUpdateFlake = {
    enable = true;
    flakeTarget = "netbox";
    interval = "1m";
  };

  services.netbox = {
    enable = true;
    secretKeyFile = "${netboxSecretPath}";
    settings = {
      DEBUG = "True";
      CSRF_TRUSTED_ORIGINS = [ "http://${testIP}" ];
    };
  };

  services.nginx = {
    enable = true;
    user = "netbox";
    recommendedTlsSettings = false;
    clientMaxBodySize = "25m";

    virtualHosts."${testIP}" = {
      locations = {
        "/" = {
          proxyPass = "http://[::1]:8001";
        };
        "/static/" = { alias = "${config.services.netbox.dataDir}/static/"; };
      };
      serverName = "${testIP}";
    };
  };


  systemd.services.netboxToken = {
    description = "creates a Netbox token if it doesn't already exist";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      User = "netbox";
    };
    unitConfig = {
      ConditionPathExists="!${netboxSecretPath}";
    };
    script = ''mkdir -p /var/lib/netbox && ${pkgs.openssl}/bin/openssl rand -hex 50 > ${netboxSecretPath}'';
  };

}

