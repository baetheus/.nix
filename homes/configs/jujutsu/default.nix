{ me, ... }: {
  programs.jujutsu = with me; {
    enable = true;
    enableZshIntegration = true;
    settings = {
      user.name = name;
      user.email = email;
    };
  };
}
