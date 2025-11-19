{
  config,
  pkgs,
  lib,
  ...
}:
let
  fish = config.programs.fish;
  zsh = config.programs.zsh;
  nu = config.programs.nushell;
in
{
  imports = lib.listFilePaths ./file_browser;
  config = {
    home.packages = [
      pkgs.file # file type info
      pkgs.exiftool # yazi
    ];
    programs.ranger = {
      enable = false;
      settings = {
        draw_borders = "separators";
        unicode_ellipsis = true;
        update_title = true;
      };
    };
    programs.yazi = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = fish.enable;
      enableNushellIntegration = nu.enable;
      enableZshIntegration = zsh.enable;
      # plugins = {
      #   sshfs = pkgs.yaziPlugins.
      # };
      settings = {
        preview = {
          "image_filter" = "nearest";
        };
      };
    };
  };
  meta = { };
}
