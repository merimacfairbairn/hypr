{
  description = ''
    Hyprland config flake with all the dependencies
      Uses flake-parts to set up the flake outputs:

      `wrappers`, `wrapperModules` and `packages.*.*`
  '';
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    wrappers = {
      url = "github:nix-community/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    # dependencies
    otter-launcher = {
      url = "github:kuokuo123/otter-launcher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wshowkeys = {
      url = "github:voidarclabs/wshowkeys";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    woomer.url = "github:coffeeispower/woomer";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [inputs.wrappers.flakeModules.wrappers];
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      perSystem = {
        lib,
        inputs',
        pkgs,
        ...
      }: let
        runtimePkgs = with pkgs; [
          kitty
          firefox
          nemo
          grimblast
          wpaperd
          syncthing
          hyprlock
          gotify-desktop
          wayvnc
          quickshell
          way-edges
          waybar

          inputs'.otter-launcher.packages.default
          inputs'.wshowkeys.packages.default
          inputs'.woomer.packages.default
        ];
      in {
        packages = {
          default = inputs.wrappers.wrappers.hyprland.wrap {
            inherit pkgs runtimePkgs;

            package = inputs'.hyprland.packages.default;

            env."MODULES_ROOT" = lib.mkDefault ./modules;
            env."HYPRLAND_ROOT" = ./.;
            configFile = ./hyprland.lua;
          };
        };
      };
    };
}
