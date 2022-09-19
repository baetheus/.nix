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

      "net.null.pub" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8080";
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

  # Headscale
  environment.systemPackages = with pkgs; [ headscale ];

  services.headscale = {
    enable = true;
    serverUrl = "https://net.null.pub";

    settings = {
      "ip_prefixes" = [ "10.10.10.0/10" ];
    };

    dns = {
      magicDns = true;
      nameservers = [ "1.1.1.1" ];
      domains = [ "net.internal" ];
      baseDomain = "net.internal";
    };
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
