{
  description = "Home manager configuration - base";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # shell
    fishFzf = {
      url = "github:PatrickF1/fzf.fish";
      flake = false;
    };
    tokyonight = {
      url = "github:folke/tokyonight.nvim";
      flake = false;
    };
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      ...
    }:
    with builtins;
    let
      std = nixpkgs.lib;
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      nixpkgsFor = std.genAttrs systems (
        system:
        import nixpkgs {
          localSystem = builtins.currentSystem or system;
          crossSystem = system;
          overlays = [ ];
        }
      );
      homeLib = import ./lib.nix;
    in
    {
      formatter = std.mapAttrs (system: pkgs: pkgs.nixfmt-rfc-style) nixpkgsFor;
      homeModules.default =
        { ... }:
        {
          imports = [ ./home-manager.nix ];
          config = {
            home.stateVersion = "22.11";
            lib.listFilePaths = homeLib.listFilePaths;
            signal.base.homeManagerSrc = inputs.home-manager;
            programs.fish = {
              pluginSources = {
                fzf = inputs.fishFzf;
              };
              themes =
                let
                  tk = "${inputs.tokyonight}/extras/fish_themes";
                in
                {
                  tokyonight_day = "${tk}/tokyonight_day.theme";
                  tokyonight_moon = "${tk}/tokyonight_moon.theme";
                  tokyonight_night = "${tk}/tokyonight_night.theme";
                  tokyonight_storm = "${tk}/tokyonight_night.theme";
                };
            };
          };
        };
    };
}
