## Swift Dev Shell

dev shell for swift

### Usage

```shell
nix develop github:ink-splatters/swift-shell
```

### Note about SwiftPM

if you want to package your swift-written software using `nix`, it's good to know
that you cannot use `swift package resolve` directly, instead the recommended way
is using `swiftpm2nix` for vendoring your SwiftPM dependencies.

See [Packaging with SwiftPM](https://nixos.org/manual/nixpkgs/stable/#ssec-swift-packaging-with-swiftpm)
