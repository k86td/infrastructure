{ pkgs, lib, config, ... }:
let
  fileListImport = paths: (lib.attrsets.mergeAttrsList (map (path: import path { inherit pkgs; }) paths));
  sysadminUsers = [
    ./users/tlepine.nix
    ./users/cgrenier.nix
  ];

  niveau3 = [ ./users/niveau3.nix ];
in {

  options = {
    groups.sysadmin.enable = lib.mkEnableOption "Should the sysadmin users be included?";

    groups.niveau3.enable = lib.mkEnableOption "Should the niveau 3 users be included?";
  };

  config = {
    users.users = fileListImport (
      # check each groups if we need to import them, merge the lists together and pass them to fileListImport.
      # this will return the required format for `users.users` to create the users.
      (if config.groups.sysadmin.enable then sysadminUsers else [])
      ++ (if config.groups.niveau3.enable then niveau3 else [])
    );
  };
}
