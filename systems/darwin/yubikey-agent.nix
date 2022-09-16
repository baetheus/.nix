{
  # services.yubikey-agent has not been merged into nix-darwin
  imports = [
    ../modules/yubikey-agent.nix
  ];

  services.yubikey-agent.enable = true;
}
