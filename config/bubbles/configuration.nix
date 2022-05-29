{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # General
  system.stateVersion = "22.05";

  networking.hostName = "bubbles";
  networking.hostId = "e23f69c3";
  networking.firewall.allowedTCPPorts = [ 22 80 443 ];

  # Secrets
  age.secrets.vaultwarden.file = ../../secrets/vaultwarden.age;

  # Nginx
  security.acme.acceptTerms = true;
  security.acme.email = "admin@null.pub";

  services.nginx = {
    enable = true;

    virtualHosts = {
      "bubbles.nll.sh" = {
        forceSSL = true;
        enableACME = true;
        root = "/var/www/bubbles.nll.sh";
      };

      "vault.nll.sh" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://0.0.0.0:8000";
        };
        locations."/notifications/hub" = {
          proxyPass = "http://0.0.0.0:3012";
          proxyWebsockets = true;
        };
      };
    };
  };

  # Services
  services.vaultwarden = {
    enable = true;
    config = {
      DOMAIN = "https://vault.nll.sh";
      WEBSOCKET_ENABLED = "true";
      SMTP_HOST = "smtp.fastmail.com";
      SMTP_FROM = "noreply@null.pub";
      SMTP_FROM_NAME = "Vaultwarden";
      SMTP_PORT = "465";
      SMTP_SSL = "true";
      SMTP_EXPLICIT_SSL = "true";
    };
    environmentFile = config.age.secrets.vaultwarden.path;
  };
}
