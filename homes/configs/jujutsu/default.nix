{ me, pkgs, ... }: {
  programs.jujutsu = with me; {
    enable = true;
    package = pkgs.jujutsu;
    settings = {
      user.name = name;
      user.email = email;
      signing = {
        behavior = "own";
        backend = "ssh";
        key = "~/.ssh/id_ed25519_sk_rk_default.pub";
      };
    };
  };
}
