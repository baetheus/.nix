{ more, ... }: {
  programs.git = with more; {
    enable = true;
    userEmail = email;
    userName = name;
    ignores = [ "*.DS_Store" "*~" "*.swp" ".direnv" ];
    aliases = {
      ll = "log --oneline";
    };
    extraConfig.init.defaultBranch = "main";
  };
}
