{ me, ... }: {
  programs.git = with me; {
    enable = true;
    userEmail = email;
    userName = name;
    ignores = [ "*.DS_Store" "*~" "*.swp" ".direnv" ];
    aliases = {
      ll = "log --oneline";
    };
    extraConfig = {
      init.defaultBranch = "main";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowedGitSigners";
    };
    signing = {
      format = "ssh";
      key = "~/.ssh/id_ed25519_sk_rk_default.pub";
      signByDefault = true;
    };
  };
}
