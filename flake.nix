{
  description = "Home manager configuration - base";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    alejandra = {
      url = github:kamadorueda/alejandra;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    homelib = {
      url = github:signalwalker/lib.home.nix;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.alejandra.follows = "alejandra";
    };
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    homelib,
    ...
  }:
    with builtins; let
      std = nixpkgs.lib;
      hlib = homelib.lib;
      nixpkgsFor = hlib.genNixpkgsFor {
        inherit nixpkgs;
        overlays = [];
      };
    in {
      formatter = std.mapAttrs (system: pkgs: pkgs.default) inputs.alejandra.packages;
      homeManagerModules.default = let
        stateVersion = "22.11";
      in
        {
          lib,
          options,
          config,
          specialArgs,
          modulesPath,
        }: {
          options = with lib; {
            # signal.base.enable = (mkEnableOption "base configuration") // {default = true;};
            system.isNixOS = (mkEnableOption "allows configuration specific to NixOS systems") // {default = true;};
          };
          imports = [
            ./home-manager.nix
          ];
          config = {
            lib.signal = hlib;
            home.stateVersion = stateVersion;
          };
        };
      homeConfigurations =
        mapAttrs (system: pkgs: {
          default = hlib.genHomeConfiguration {
            inherit pkgs inputs;
          };
        })
        nixpkgsFor;
      packages = hlib.genHomeActivationPackages self.homeConfigurations;
      apps = hlib.genHomeActivationApps self.homeConfigurations;
    };
}