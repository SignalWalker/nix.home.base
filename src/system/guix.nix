{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options = with lib; {};
  disabledModules = [];
  imports = [];
  config = lib.mkIf osConfig.services.guix.enable {
    xdg.configFile."guix/channels.scm".source = ./guix/channels.scm;
  };
  meta = {};
}
