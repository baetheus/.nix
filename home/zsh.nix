{
  enable = true;
  dotDir = ".local/zsh";
  defaultKeymap = "viins"; # Use vi for insert mode
  initExtra = "PROMPT=\"%n@%B%m%b %~ %# \"";

  shellAliases = {
    ll = "ls -alhG"; # Pretty ll
    vi = "vim"; # Prefer vim
    switch = "darwin-rebuild switch --flake ~/.nix";
    flake = "nix flake new -t github:nix-community/nix-direnv .";
  };

  history = {
    share = true;
    ignoreDups = true;
    path = "$ZDOTDIR/.zsh_history";
  };

  enableCompletion = true;
  enableSyntaxHighlighting = true;
}
