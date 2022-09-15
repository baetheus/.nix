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
      commit.gpgsign = true;
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      user.signingkey = signingkey;
    };
  };
}
