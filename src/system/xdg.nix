{
  config,
  osConfig,
  pkgs,
  lib,
  homeBaseInputs,
  ...
}:
let
  xdg = config.xdg;
  userDirs = xdg.userDirs;
  nix = osConfig.nix;
in
{
  options.xdg =
    with lib;
    let
      fileType = config.lib.hm.types.file;
    in
    {
      userDirs.templateFile = mkOption {
        type = fileType "<varname>xdg.userDirs.templates</varname>" "" config.xdg.userDirs.templates;
        default = { };
      };
      binFile = mkOption {
        type = fileType "<varname>xdg.binHome</varname>" "" config.xdg.binHome;
        default = { };
      };
    };
  imports = [ ];
  config = {
    lib.hm.types.file =
      (import "${homeBaseInputs.home-manager}/modules/lib/file-type.nix" {
        inherit (config.home) homeDirectory;
        inherit lib pkgs;
      }).fileType;
    home.file = lib.mkMerge [
      (lib.mapAttrs' (
        name: file: lib.nameValuePair "${xdg.userDirs.templates}/${name}" file
      ) xdg.userDirs.templateFile)
      (lib.mapAttrs' (name: file: lib.nameValuePair "${xdg.binHome}/${name}" file) xdg.binFile)
    ];
    home.preferXdgDirectories = true;

    xdg =
      let
        home = config.home.homeDirectory;
      in
      {
        enable = true;
        cacheHome = "${home}/.cache";
        configHome = "${home}/.config";
        stateHome = "${home}/.local/state";
        dataHome = "${home}/.local/share";
        binHome = "${home}/.local/bin";
        localBinInPath = true;
        systemDirs = {
          data =
            (
              if nix.settings.use-xdg-base-directories then
                [ "${xdg.stateHome}/nix/profile" ]
              else
                [ "${home}/.nix-profile" ]
            )
            ++ (
              if osConfig.services.flatpak.enable then
                [
                  "/usr/share" # TODO :: why /usr/share...? that doesn't exist in nixos...?
                  "/var/lib/flatpak/exports/share"
                  "${xdg.dataHome}/flatpak"
                ]
              else
                [ ]
            );
        };
        userDirs = {
          enable = true;
          createDirectories = true;
          setSessionVariables = true;
          desktop = "${home}/desktop";
          documents = "${home}/documents";
          download = "${home}/downloads";
          music = "${home}/music";
          pictures = "${home}/pictures";
          publicShare = "${home}/public";
          templates = "${home}/templates";
          videos = "${home}/video";
          extraConfig = {
            PROJECTS = "${home}/projects";
            NOTES = "${home}/notes";
            BACKUP = "${home}/backup";
            SOURCE = "${home}/src";
            GAMES = "${home}/games";
            BOOKS = "${home}/books";
            SCREENSHOTS = "${userDirs.pictures}/screenshots";
            WALLPAPERS = "${userDirs.pictures}/wallpapers";
          };
        };
      };
  };
}
