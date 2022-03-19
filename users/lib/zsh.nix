{
  enable = true;
  dotDir = ".local/zsh";
  defaultKeymap = "viins"; # Use vi for insert mode
  initExtra = "PROMPT=\"%n@%B%m%b %~ %# \"";

  shellAliases = {
    ll = "ls -alhG"; # Pretty ll
    vi = "vim"; # Prefer vim
    grep = "rg"; # Prefer rg
  };

  history = {
    share = true;
    ignoreDups = true;
    path = "$ZDOTDIR/.zsh_history";
  };

  enableCompletion = true;
  enableSyntaxHighlighting = true;
}
