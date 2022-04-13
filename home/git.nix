{ email ? "name@example.com", name ? "Anonymous" }: {
  enable = true;
  userEmail = email;
  userName = name;
  ignores = [ "*.DS_Store" "*~" "*.swp" ];
  aliases = {
    ll = "log --oneline";
  };
  extraConfig.init.defaultBranch = "main";
}
