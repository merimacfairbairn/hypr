{
  description = "Hyprland config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wrapper-modules = {
      url = "github:nix-community/nix-wrapper-modules";
    };

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
      systems = ["x86_64-linux"];

      perSystem = {
        pkgs,
        system,
        ...
      }: let
        hypr = inputs.hyprland.packages.${system}.default;

        externalPackage = name:
          inputs.${name}.packages.${system}.default;

        runtimePackages = {
          inherit
            (pkgs)
            kitty
            firefox
            nemo
            grimblast
            wpaperd
            syncthing
            hyprlock
            wayvnc
            quickshell
            way-edges
            waybar
            ;

          otter-launcher = externalPackage "otter-launcher";
          wshowkeys = externalPackage "wshowkeys";
          woomer = externalPackage "woomer";
        };

        wrappedHyprland = inputs.wrapper-modules.lib.wrapPackage {
          inherit pkgs;

          package = hypr;

          env = {
            MODULES_ROOT = ./modules;
            HYPRLAND_ROOT = ./.;
          };

          flags = {
            "--config" = ./hyprland.lua;
          };

          passthru.runtimePackages = runtimePackages;
        };

        repoSrc = pkgs.lib.cleanSourceWith {
          src = ./.;
          filter = path: type: let
            name = builtins.baseNameOf path;
          in
            !(builtins.elem name [
              ".git"
              ".gitignore"
              "result"
              ".direnv"
            ]);
        };

        repoFiles = pkgs.stdenvNoCC.mkDerivation {
          pname = "hyprland-repo-files";
          version = "1.0";
          src = repoSrc;
          dontBuild = true;

          installPhase = ''
            mkdir -p "$out"
            cp -r . "$out/"
          '';
        };
      in {
        packages = {
          default = wrappedHyprland;
          repo-files = repoFiles;
        };

        # Retains original public runtime-package output.
        lib.defaultRuntimePkgs = runtimePackages;
      };
    };
}
