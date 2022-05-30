{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # General
  system.stateVersion = "22.05";

  networking.hostName = "buttercup";
  networking.hostId = "e23f69c4";
  networking.firewall.allowedTCPPorts = [ 22 80 443 ];

  # Secrets
  # age.secrets.vaultwarden.file = ../../secrets/vaultwarden.age;

  # Nginx
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "admin@null.pub";

  services.nginx = {
    enable = true;

    virtualHosts = {
      "buttercup.nll.sh" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          root = "/var/www/buttercup.nll.sh";
          extraConfig = "autoindex on;";
        };
      };
    };
  };

  # Services
  services.plex = {
    enable = true;
    user = "plex";
    group = "media";
    dataDir = "/media";
    openFirewall = true;
  };
}
