inputs@{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = lib.listFilePaths ./programs;
  config = {
    home.packages = with pkgs; [
      procs
      du-dust
      calc
      killall
      p7zip-rar
      unzip
      unrar
      unar
    ];

    programs.btop = {
      enable = true;
    };

    programs.info.enable = true;
  };
}

