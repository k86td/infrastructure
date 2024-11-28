{ pkgs, ... }:
{
  niveau3 = {
    isNormalUser = true;
    packages = with pkgs; [
      vim
      git
    ];
  };
}
