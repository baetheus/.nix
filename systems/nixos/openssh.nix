{ ... }: {
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
    extraConfig = "PubkeyAuthOptions verify-required";
  };
}
