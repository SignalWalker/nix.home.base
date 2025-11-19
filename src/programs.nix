{
  pkgs,
  lib,
  ...
}:
{
  imports = lib.listFilePaths ./programs;
  config = {
    home.packages = [
      # system
      pkgs.procs
      pkgs.dust
      pkgs.calc
      pkgs.killall
      # archives
      pkgs.ouch
      pkgs.p7zip-rar
      pkgs.unzip
      pkgs.unrar
      pkgs.unar
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
