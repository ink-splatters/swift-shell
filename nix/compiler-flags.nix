{
  lib,
  llvmPackages_19,
  maxPerfUnhardened ? false,
  maxPerf ? maxPerfUnhardened,
  isThinLTO ? false,
  isLTO ? maxPerf,
  isLLD ? true,
  ...
}:
let
  inherit (llvmPackages_19) stdenv clang;

  oneOf =
    cond: lst1: lst2:
    if cond then lst1 else lst2;
  opt = cond: lst: oneOf cond lst [ ];

  flags =
    opt stdenv.isDarwin [ "-mcpu=apple-m1" ]
    ++ oneOf maxPerf [ "-O3" ] [ "-O2" ]
    ++ opt maxPerf [ "-ffast-math" ]
    ++ opt maxPerf [ "-mtune=native" ]
    ++ opt maxPerf [ "-funroll-loops" ]
    ++ opt isThinLTO [ "-flto=thin" ]
    ++ opt (isLTO && !isThinLTO) [ "-flto" ];

  stdlib = "-stdlib libc++";

  inherit (builtins) concatStringsSep readFile;
  getNixCompilerFlags =
    lst: map (flags: (lib.removeSuffix "\n" (readFile "${clang}/nix-support/${flags}"))) lst;

  mergeFlags = lst: concatStringsSep " " lst;

  hardeningDisable = opt maxPerfUnhardened [ "all" ];

  CFLAGS = mergeFlags (
    flags
    ++ getNixCompilerFlags [
      "cc-cflags"
      "libc-cflags"
    ]
  );
  CXXFLAGS = mergeFlags (flags ++ getNixCompilerFlags [ "libcxx-cxxflags" ]);
  LDFLAGS = "${stdlib} " + lib.optionalString isLLD "-fuse-ld=lld";

in
{
  inherit
    CFLAGS
    CXXFLAGS
    LDFLAGS
    hardeningDisable
    ;
}
