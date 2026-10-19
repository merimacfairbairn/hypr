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

          inputs'.packages.otter-launcher.default
          inputs'.packages.wshowkeys.default
          inputs'.packages.woomer.default
        ];
      in {
        packages = {
          default = inputs.wrappers.wrappers.hyprland.wrap {
            inherit pkgs runtimePkgs;

            package = inputs'.package.hyprland.default;
            exePath = pkgs.lib.getExe inputs'.package.hyprland.default;
            env."MODULES_ROOT" = ./modules;
            env."HYPRLAND_ROOT" = ./.;
            flags."--config" = ./hyprland.lua;
          };
        };
      };
    };
}
