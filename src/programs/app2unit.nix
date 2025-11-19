{
  config,
  pkgs,
  lib,
  ...
}:
let
  app2unit = config.programs.app2unit;
in
{
  options = {
    programs.app2unit = {
      enable = lib.mkEnableOption "app2unit runner";
      package = lib.mkPackageOption pkgs "app2unit" { };
      defaultUnitType = lib.mkOption {
        type = lib.types.enum [
          "scope"
          "service"
        ];
        default = "scope";
      };
      slices = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = {
          a = "app-graphical.slice";
          b = "background-graphical.slice";
          s = "session-graphical.slice";
        };
      };
    };
  };
  config = lib.mkIf app2unit.enable {
    home.packages = [ app2unit.package ];
    systemd.user.sessionVariables = {
      "APP2UNIT_SLICES" = lib.concatStringsSep " " (
        lib.mapAttrsToList (name: value: "${name}=${value}") app2unit.slices
      );
      "APP2UNIT_TYPE" = app2unit.defaultUnitType;
    };
  };
  meta = { };
}
