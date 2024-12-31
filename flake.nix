{
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";

    systems.url = "github:nix-systems/default";
    flake-utils.inputs.systems.follows = "systems";

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = { nixpkgs.follows = "nixpkgs"; };
    };
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
  };

  nixConfig = {
    extra-substituters = [ "https://pre-commit-hooks.cachix.org" ];
    extra-trusted-public-keys = [
      "aarch64-darwin.cachix.org-1:mEz8A1jcJveehs/ZbZUEjXZ65Aukk9bg2kmb0zL9XDA="
      "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
    ];
  };

  outputs = { flake-utils, nixpkgs, git-hooks, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pre-commit = pkgs.callPackage ./nix/pre-commit.nix {
          inherit git-hooks system;
          src = ./.;
        };
      in {
        checks = { inherit (pre-commit) check; };

        apps = { inherit (pre-commit) install-hooks; };

        formatter = pkgs.nixfmt-classic;
        devShells.default = pkgs.callPackage ./nix/dev-shell.nix { };
      });
}
