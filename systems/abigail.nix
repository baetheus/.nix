{ config, pkgs, ... }:

{
  imports = [ ./bundles/sys-1-sat-32.nix ];

  # General
  system.stateVersion = "22.05";

  networking.hostName = "abigail";
  networking.hostId = "a9a768fa";
  networking.firewall.allowedTCPPorts = [ 22 80 443 ];

  # Secrets
  age.secrets.vaultwarden.file = ../secrets/vaultwarden.age;
  age.secrets.innernet.file = ../secrets/innernet-config.age;

  # Nginx
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "admin@null.pub";

  services.nginx = {
    enable = true;

    virtualHosts = {
      "abigail.null.pub" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          root = "/var/www/abigail.null.pub";
          extraConfig = "autoindex on;";
        };
      };

      "vault.null.pub" = {
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

  # Innernet
  services.innernet = {
    enable = true;
    configFile = config.age.secrets.innernet.path;
    interfaceName = "innernet0";
    openFirewall = true;
  };


  # Provides a private bitwarden server
  services.vaultwarden = {
    enable = true;
    config = {
      DOMAIN = "https://vault.null.pub";
      WEBSOCKET_ENABLED = "true";
    };
    environmentFile = config.age.secrets.vaultwarden.path;
  };
}
