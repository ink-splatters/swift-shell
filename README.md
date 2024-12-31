## Nix development shell for Swift

<details>
<summary>Ensure `flakes` support is enabled</summary>

if not done yet, add:

```nix
experimental-features = nix-command flakes
```

to your `nix.conf`<sup>1</sup>.

Alternatively, you may pass `--experimental-features` CLI argument
to `nix` invocations below.

--
<sup>1></sup> either to `/etc/nix/nix.conf` or to `~/.config/nix/nix.conf`.
for NixOS, see the corresponding manual.

</details>

### Usage

```shell
nix  develop github:ink-splatters/swift-shell
```

### Development

```sh
nix run .#install-hooks
nix run nixpkgs#direnv -- allow # or `nix develop` if you don't want to use `direnv`
```

any changes to `git-hooks` configuration must be followed by running `nix run .#install-hooks`

### SwiftPM

See [Packaging with SwiftPM](https://nixos.org/manual/nixpkgs/stable/#ssec-swift-packaging-with-swiftpm)

TL;DR

if you want to package your swift-written software using `nix`, it's good to know
that you cannot use `swift package resolve` directly, instead the recommended way
is using `swiftpm2nix` for vendoring your SwiftPM dependencies.

### Availability of XCTest

`XCTest` uses Obj-C runtime which is not part of opensource swift and cannot be shiped with `nix`.
Use swift `Testing` to be able to run tests via `nix check`
