{
  description = "basic swift development shell";

  outputs = { nixpkgs, flake-utils, self, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        hardeningDisable = [ "all" ];


        mkSh = args: with pkgs; mkShell.override { inherit (llvmPackages_latest) stdenv; }
          {

            shellHook = ''
              export PS1="\n\[\033[01;32m\]\u $\[\033[00m\]\[\033[01;36m\] \w >\[\033[00m\] "
            '';

            SWIFTFLAGS = "-mcpu native";

            nativeBuildInputs = with swiftPackages; [
              swift
              swiftpm
              xcodebuild

            ];
          } // args;
      in
      with pkgs; {
        formatter = nixpkgs-fmt;
        devShells = {
          default = mkSh { };
          O3 = mkSh {
            SWIFTFLAGS = "${SWIFTFLAGS} -O3";
          };

          unhardened = mkSh {
            inherit hardeningDisable;
          };

          O3-unhardened = mkSh {
            inherit hardeningDisable;
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
      });
}
