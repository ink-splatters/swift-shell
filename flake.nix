{
  description = "basic cpp development shell";

  outputs = { nixpkgs, flake-utils, self, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        hardeningDisable = [ "all" ];

        shellHook = ''
          export PS1="\n\[\033[01;32m\]\u $\[\033[00m\]\[\033[01;36m\] \w >\[\033[00m\] "
        '';

        SWIFTFLAGS = "-mcpu native";

        mkShell = let
          inherit (pkgs) swiftPackages mkShell;
        in
          mkShell.override { inherit (swiftPackages) stdenv; };

        nativeBuildInputs = with swiftPackages; [
          swift
          swiftpm
          xcodebuild
        ];
      in {
        formatter = pkgs.nixpkgs-fmt;
        devShells = {
          default = mkShell {
            inherit SWIFTFLAGS shellHook nativeBuildInputs;
          };

          O3 = mkShell {
            inherit shellHook nativeBuildInputs;
            SWIFTFLAGS = "${SWIFTFLAGS} -O3";
          };

          unhardened = mkShell {
            inherit SWIFTFLAGS shellHook nativeBuildInputs hardeningDisable;
          };

          O3-unhardened = mkShell {
            inherit shellHook nativeBuildInputs hardeningDisable;
            SWIFTFLAGS = "${SWIFTFLAGS} -O3";
          };
        };

          # TODO: integrate and make working  (cannot pull remote deps)
          # checks.default = pkgs.stdenv.mkDerivation {
          #   inherit (self.devShells.${system}.default) nativeBuildInputs hardeningDisable CXXFLAGS;

          #   name = "check";
          #   src = ./checks/swift;
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
