{ pkgs, git-hooks, src, system, ... }:
git-hooks.lib.${system}.run {
  inherit src;

  hooks = {
    deadnix.enable = true;
    markdownlint = {
      enable = true;
      settings.configuration.MD041.level = "2";
    };
    nil.enable = true;
    nixfmt-rfc-style.enable = true;
    statix.enable = true;
    shellcheck.enable = true;
    shfmt.enable = true;
  };

  tools = pkgs;
}
