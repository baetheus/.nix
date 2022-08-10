{ git, ... }: {
  programs.git = {
    enable = true;
    userEmail = git.email;
    userName = git.name;
    ignores = [ "*.DS_Store" "*~" "*.swp" ".direnv" ];
    aliases = {
      ll = "log --oneline";
    };
    extraConfig.init.defaultBranch = "main";
  };
}
