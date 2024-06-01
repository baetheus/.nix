{ me, pkgs, ... }: {
  programs.jujutsu = with me; {
    enable = true;
    package = pkgs.jujutsu;
    settings = {
      user.name = name;
      user.email = email;
    };
  };
}
