{
  description = "basic swift development shell";

  nixConfig = {
    extra-substituters = [
      "https://aarch64-darwin.cachix.org"
    ];
    extra-trusted-public-keys = [
      "aarch64-darwin.cachix.org-1:mEz8A1jcJveehs/ZbZUEjXZ65Aukk9bg2kmb0zL9XDA="
    ];
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      self,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        hardeningDisable = [ "all" ];

        CFLAGS = pkgs.lib.optionalString ("${system}" == "aarch64-darwin") "-mcpu=apple-m1";
        CXXFLAGS = CFLAGS;
        SWIFTFLAGS = CXXFLAGS;

        mkSh =
          args:
          with pkgs;
          mkShell.override { inherit (swift) stdenv; } {
            inherit CFLAGS CXXFLAGS SWIFTFLAGS;

            shellHook = ''
              export PS1="\n\[\033[01;32m\]\u $\[\033[00m\]\[\033[01;36m\] \w >\[\033[00m\] "
            '';

            nativeBuildInputs = with pkgs; [
              swift
              swiftpm
              xcodebuild
            ];
          }
          // args;
      in
      with pkgs;
      {
        formatter = pkgs.nixfmt-rfc-style;
        devShells = {
          default = mkSh { };
          O3 = mkSh {
            CFLAGS = "${CFLAGS} -O3";
            CXXFLAGS = "${CXXFLAGS} -O3";
            SWIFTFLAGS = "${SWIFTFLAGS} -O3";
          };

          unhardened = mkSh { inherit hardeningDisable; };

          O3-unhardened = mkSh {
            inherit hardeningDisable;
            CFLAGS = "${CFLAGS} -O3";
            CXXFLAGS = "${CXXFLAGS} -O3";
            SWIFTFLAGS = "${SWIFTFLAGS} -O3";
          };
        };

        # TODO: make work
        # checks.default = let
        #   shell = self.devShells.${system}.default;
        #   inherit (shell) stdenv;
        # in
        #  stdenv.mkDerivation {
        #   inherit  (shell) SWIFTFLAGS nativeBuildInputs;
        #   name = "check";
        #   src = ./checks;
        #   dontBuild = true;
        #   doCheck = true;

        #   checkPhase = ''
        #     swift build -c release
        #   '';
        #   installPhase = ''
        #     mkdir "$out"
        #   '';
        # };
      }
    );
}
