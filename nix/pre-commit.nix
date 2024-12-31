{ pkgs, git-hooks, src, system, ... }: rec {
  check = git-hooks.lib.${system}.run {
    inherit src;

    hooks = {
      deadnix.enable = true;
      markdownlint = {
        enable = true;
        settings.configuration = {
          MD013.line_length = 110;
          MD033.allowed_elements = [ "sup" "details" "summary" ];
          MD041.level = 2;
        };
      };
      nil.enable = true;
      nixfmt-classic.enable = true;
      statix.enable = true;
      shellcheck.enable = true;
      shfmt.enable = true;
    };

    tools = pkgs;
  };

  install-hooks = {
    type = "app";
    program = toString (pkgs.writeShellScript "install-hooks" ''
      ${check.shellHook}
      echo Done!
    '');
    meta.description = "install pre-commit hooks";
  };
}
