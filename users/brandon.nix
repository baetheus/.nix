{ pkgs, ... }:

{
  home = {
    username = "brandon";
    stateVersion = "21.11";

    sessionVariables = {
      EDITOR = "vim";
    };

    packages = with pkgs; [
      deno
      jq
      kubectl
      lima
      ripgrep
      rustup
    ];
  };

  programs = {
    direnv.enable = true;
    direnv.nix-direnv.enable = true;

    home-manager.enable = true;

    zsh = {
      enable = true;
      dotDir = ".local/zsh";
      defaultKeymap = "viins"; # vi insert mode
      envExtra = "PROMPT=\"%n@%B%m%b $~ %#\"";

      shellAliases = {
        ll = "ls -alhG"; # Pretty ll
        vi = "vim"; # We use vim not vi
        grep = "rg"; # We use ripgrep not grep
      };

      history = {
        share = true;
        ignoreDups = true;
        path = "$ZDOTDIR/.zsh_history";
      };

      enableCompletion = true;
      enableSyntaxHighlighting = true;
    };

    vim = import ./lib/vim.nix { inherit pkgs; };

    git = {
      enable = true;
      userEmail = "brandon@null.pub";
      userName = "Brandon Blaylock";
      ignores = [ "*.DS_Store" "*~" "*.swp" ];
      aliases = {
        ll = "log --oneline";
      };
    };
  };


}
