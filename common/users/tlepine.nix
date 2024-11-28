{ pkgs, ... }:
{
  tlepine = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      vim
      git
    ];
  };
}
