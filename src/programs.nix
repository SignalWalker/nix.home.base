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

    # programs.bottom = {
    #   enable = true;
    #   settings = {
    #     disk = {
    #       name_filter = {
    #         is_list_ignored = true;
    #         list = [ "bpool" ];
    #       };
    #     };
    #     flags = {
    #       group_processes = true;
    #     };
    #   };
    # };

    programs.info.enable = true;
  };
}
