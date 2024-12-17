{
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
    flake-utils.inputs.systems.follows = "systems";

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
        # nixpkgs-stable.follows = "nixpkgs";
      };
    };
  };

  outputs =
    {
      flake-utils,
      nixpkgs,
      git-hooks,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pre-commit-check = pkgs.callPackage ./pre-commit-check.nix {
          inherit git-hooks system;
          src = ./.;
        };
      in
      {

        checks = {
          inherit pre-commit-check;
        };

        apps.install-hooks = {
          type = "app";
          program = toString (
            pkgs.writeShellScript "install-hooks" ''
              ${pre-commit-check.shellHook}
              echo Done!
            ''
          );
          meta.description = "install pre-commit hooks";
        };

        devShells.default = pkgs.mkShell.override { inherit (pkgs.swiftPackages) stdenv; } {

          nativeBuildInputs = [
            pkgs.swift
            pkgs.swiftpm
            pkgs.swiftpm2nix

          ];
          inherit (pre-commit-check) shellHook;
        };

        formatter = pkgs.nixfmt-rfc-style;
      }
    );
}
