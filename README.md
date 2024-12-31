# Nix development shell for Swift

Requires nix [flakes](https://nixos.wiki/wiki/Flakes) support.

## Usage

```shell
nix develop github:ink-splatters/swift-shell
```

## Development

### direnv

It's recommended to install `direnv`:

```sh
nix profile install nixpkgs#direnv
```

#### POSIX shell integration

```sh
shell_name=$(basename $SHELL)
[[ $shell_name == "bash" ]] && rc=~/.bashrc
[[ $shell_name == "zsh" ]] && rc=~/.zshrc

cat <<'EOF' >> $rc

# direnv shell integration
eval "$(direnv hook $SHELL)"
EOF
source $rc
```

#### fish support

install the integration support via `fisher`:

```fish
fisher install halostatue/fish-direnv@v1.x
```

then reload your shell configuration.

### Enter development environment

```sh
nix run .#install-hooks
direnv allow .
nix develop
```

NOTE: any changes to `git-hooks` configuration must be followed by running `nix run .#install-hooks`

### SwiftPM

If you want to package your SwiftPM project with `nix`, you should use `swiftpm2nix` 
for vendoring dependencies.

See [Packaging with SwiftPM](https://nixos.org/manual/nixpkgs/stable/#ssec-swift-packaging-with-swiftpm)

### Availability of XCTest

`XCTest` uses Obj-C runtime which is not part of opensource swift and cannot be shiped with `nix`, therefore
it's recommended to use swift `Testing` instead.
