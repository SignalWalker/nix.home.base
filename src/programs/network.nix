{
  config,
  pkgs,
  lib,
  ...
}:
with builtins;
{
  options = { };
  disabledModules = [ ];
  imports = [ ];
  config = {
    # fancy ping/traceroute/mtr
    programs.trippy = {
      enable = true;
    };
  };
  meta = { };
}
