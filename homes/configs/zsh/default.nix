{ pkgs, ... }: {
  home.packages = with pkgs; [
    openssh # For a good ssh-agent
    zsh-completions # For completions
  ];

  programs.zsh = {
    enable = true;
    dotDir = ".local/zsh";
    defaultKeymap = "viins"; # Use vi for insert mode
    initExtra = ''
      PROMPT="%n@%B%m%b %# "
      RPROMPT="%~"
      eval `ssh-agent`;
      new() {
        nix flake new -t ~/share/src/nix#$1 $2
      }
    '';

    shellAliases = {
      ll = "ls -alhG"; # Pretty ll
      vi = "vim"; # Prefer vim
      sw = if pkgs.stdenv.isDarwin
        then "darwin-rebuild switch --flake ~/share/src/nix"
        else "nixos-rebuild switch --flake ~/share/src/nix --use-remote-sudo";
    };

    history = {
      share = true;
      ignoreDups = true;
      path = "$ZDOTDIR/.zsh_history";
    };

    enableCompletion = true;
    enableSyntaxHighlighting = true;
  };
}
