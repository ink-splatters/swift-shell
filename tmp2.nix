{
  description = "basic cpp development shell";

  inputs = {
    systems.url = "github:nix-systems/default";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs";
      };
    };
  };

  nixConfig = {
    extra-substituters = "https://cachix.cachix.org";
    extra-trusted-public-keys = "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM=";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      git-hooks,
      self,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        inherit (pkgs) callPackage;
      in
      {

        checks.pre-commit-check = callPackage ./nix/pre-commit-check.nix { inherit git-hooks system; };

        formatter = pkgs.nixfmt-rfc-style;

        devShells = callPackage ./nix/shells.nix { inherit (self.checks.${system}) pre-commit-check; };
      }
    );
}
