{ mkShell, swiftPackages, ... }:
let
  inherit (swiftPackages)
    sourcekit-lsp stdenv swift-docc swift-format swiftpm swiftpm2nix swift;

in mkShell.override { inherit stdenv; } {
  nativeBuildInputs =
    [ sourcekit-lsp swift-docc swift-format swiftpm swiftpm2nix swift ];
}
