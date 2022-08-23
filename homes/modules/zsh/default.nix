{ ... }: {
  programs.zsh = {
    enable = true;
    dotDir = ".local/zsh";
    defaultKeymap = "viins"; # Use vi for insert mode
    initExtra = ''
      PROMPT="%n@%B%m%b %# "
      RPROMPT="%~"
      export DENO_INSTALL="/Users/brandon/.deno"
      export PATH="$DENO_INSTALL/bin:$PATH"
    '';

    shellAliases = {
      ll = "ls -alhG"; # Pretty ll
      vi = "vim"; # Prefer vim
      swdarwin = "darwin-rebuild switch --flake ~/.nix";
      swnixos = "nixos-rebuild switch --flake ~/.nix --use-remote-sudo";
      flake = "nix flake new -t github:nix-community/nix-direnv .";
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
