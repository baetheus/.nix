{ me, pkgs, ... }: {
  programs.jujutsu = with me; {
    enable = true;
    package = pkgs.jujutsu;
    enableZshIntegration = true;
    settings = {
      user.name = name;
      user.email = email;
    };
  };
}
