{ pkgs, ... }:
{
  cgrenier = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      vim
      git
      tmux
    ];
  };
}
