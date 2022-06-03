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

  # Users and Groups
  users = {
    users.media = {
      group = "media";
      isSystemUser = true;
    };
    groups.media = {
      members = [ "media" "brandon" ];
    };
  };

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

      "plex.null.pub" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://0.0.0.0:32400";
          proxyWebsockets = true;
        };
      };
    };
  };

  # Plex Media Server
  services.plex = {
    enable = true;
    user = "media";
    group = "media";
  };

  services.nzbget = {
    enable = true;
    user = "media";
    group = "media";
  };
}
