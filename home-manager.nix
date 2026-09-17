{
  lib,
  ...
}:
{
  options = {
    system.isNixOS = (lib.mkEnableOption "allows configuration specific to NixOS systems") // {
      default = true;
    };
    signal.base.homeManagerSrc = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
    };
  };
  imports = lib.listFilePaths ./src;
  config = {
    programs.home-manager.enable = true;
    home.enableNixpkgsReleaseCheck = true;
    news.display = "notify";
  };
}
