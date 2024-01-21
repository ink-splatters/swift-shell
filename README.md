## Swift Dev Shell

barebone swift dev shell based on `nix flakes`. Contains Swift Package Manager


production ready and much more feature-rich alternative: https://devenv.sh

### Requirements

`nix` with `flake` support

to enable it, given nix is installed:

```shell
mkdir -p $HOME/.config/nix
cat <<'EOF' >> $HOME/.config/nix.conf

experimental-features = flakes nix-command

EOF
```

### Usage

- enter `swift` shell (contains `swift` and swift package manager) without cloning the repo:

```shell
nix develop github:ink-splatters/swift-shell --impure
```

- enter `swift` shell with -O3 enabled, locally:

```shell
git clone https://github:ink-splatters/swift-shell.git
cd swift-shell
nix develop .#O3
```

### Shell List

- default
- `O3`

with hardening disabled:

- `unhardened`
- `O3-unhardened`


### Example program

```shell
# enter shell
git clone https://github:ink-splatters/swift-shell.git
cd swift-shell
nix develop .#O3

cd checks
swift run -c release
```

