inputs@{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = lib.signal.fs.path.listFilePaths ./programs;
  config = {
    home.packages = with pkgs; [
      btop
      procs
      du-dust
      calc
      killall
      p7zip-rar
      unzip
      unrar
      unar
    ];

    programs.info.enable = true;
  };
}
