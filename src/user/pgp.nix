{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  gnupg = osConfig.programs.gnupg or {};
  agentEnabled = gnupg.agent.enable or false;
  dirmngrEnabled = gnupg.dirmngr.enable or false;
in {
  options = with lib; {};
  disabledModules = [];
  imports = [];
  config = lib.mkMerge [
    (lib.mkIf agentEnabled {
      home.file = {
        ".gnupg/gpg.conf" = {
          text = ''
          '';
        };
      };
    })
    (lib.mkIf dirmngrEnabled {
      home.file = {
        ".gnupg/dirmngr.conf" = {
          text = ''
            keyserver hkps://keys.openpgp.org
          '';
        };
      };
    })
  ];
  meta = {};
}
