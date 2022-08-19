{ config, pkgs, ... }:

{
  imports = [ ./bundles/sys-1-sat-32.nix ];

  # General
  system.stateVersion = "22.05";

  networking.hostName = "bubbles";
  networking.hostId = "e23f69c3";
  networking.firewall.allowedTCPPorts = [ 22 80 443 6443 10250 ];
  networking.firewall.allowedUDPPorts = [ 8472 51820 ];

  environment.systemPackages = with pkgs; [ kubectl ];

  # Secrets
  age.secrets.k3s-token.file = ../secrets/k3s-token.age;

  # k3s
  services.k3s = {
    enable = true;
    tokenFile = config.age.secrets.k3s-token.path;
  };
}
