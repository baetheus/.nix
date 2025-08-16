{ config, pkgs, ... } @ inputs:

{
  # Imports
  imports = [
    ./bundles/sys-1-sat-32.nix
  ];

  # General
  system.stateVersion = "22.05";

  networking.hostName = "abigail";
  networking.hostId = "a9a768fa";
  networking.firewall.allowedTCPPorts = [ 22 80 443 ];
  networking.firewall.allowedUDPPorts = [ 41641 ]; # Tailscale

  # Secrets
  age.secrets.vaultwarden.file = ../secrets/vaultwarden.age;

  # Nginx
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "admin@null.pub";

  services.nginx = {
    enable = true;

    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    clientMaxBodySize = "500m";

    virtualHosts = {
      "public.null.pub" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          root = "/var/www/public.null.pub";
          extraConfig = "autoindex on;";
        };
      };

      "vault.null.pub" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8000";
        };
        locations."/notifications/hub" = {
          proxyPass = "http://127.0.0.1:3012";
          proxyWebsockets = true;
        };
      };

      "net.null.pub" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/metrics" = {
            proxyPass = "http://127.0.0.1:${toString config.services.headscale.port}";
            extraConfig = ''
              allow 100.64.0.0/16;
              deny all;
            '';
            priority = 2;
          };

          "/" = {
            proxyPass = "http://127.0.0.1:${toString config.services.headscale.port}";
            proxyWebsockets = true;
            extraConfig = ''
              keepalive_requests          100000;
              keepalive_timeout           160s;
              proxy_buffering             off;
              proxy_connect_timeout       75;
              proxy_ignore_client_abort   on;
              proxy_read_timeout          900s;
              proxy_send_timeout          600;
              send_timeout                600;
            '';
            priority = 99;
          };
        };
      };

      "id.null.pub" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://[::1]:1411";
          proxyWebsockets = true;
          recommendedProxySettings = true;
          extraConfig = ''
            client_max_body_size 50000M;
            proxy_read_timeout   600s;
            proxy_send_timeout   600s;
            send_timeout         600s;
          '';
        };
      };

      "immich.null.pub" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://[::1]:${toString config.services.immich.port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
          extraConfig = ''
            client_max_body_size 50000M;
            proxy_read_timeout   600s;
            proxy_send_timeout   600s;
            send_timeout         600s;
          '';
        };
      };
    };
  };
  

  # Headscale
  environment.systemPackages = with pkgs; [ headscale ];
  services.headscale = {
    enable = true;

    settings = {
      server_url = "https://net.null.pub";
      dns = {
        magic_dns = true;
        base_domain = "rou.st";
        search_domains = [ "rou.st" ];
        nameservers.global = [ "1.1.1.1" "4.4.4.4" ];
      };
    };
  };

  # Provides a private bitwarden server
  services.vaultwarden = {
    enable = true;
    config = {
      DOMAIN = "https://vault.null.pub";
      WEBSOCKET_ENABLED = "true";
      SIGNUPS_ALLOWED = "false";
    };
    environmentFile = config.age.secrets.vaultwarden.path;
  };

  # Personal OIDC provider
  services.pocket-id = {
    enable = true;
    package = pkgs.unstable.pocket-id;
    settings = {
      TRUST_PROXY = true;
      APP_URL = "https://id.null.pub";
    };
  };

  # Syncthing
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    dataDir = "/home/brandon/sync";
    configDir = "/home/brandon/.config/syncthing";
    user = "brandon";
    group = "users";
    guiAddress = "0.0.0.0:8384";
    overrideFolders = true;
    overrideDevices = true;

    settings.devices = {
      "rosalind" = {
        id = "FIFUNFL-3QFVW3N-5P7XESL-Q7JZF4S-55B7TTY-2KG57S5-5JYAZVE-KHDOGAW";
        addresses = [ "tcp://rosalind:22000" ];
      };
      "toph" = {
        id = "X6JGCDD-4DQQTNL-VPPBNYB-PRTO4XJ-KTWLZ5O-N2DLDHP-PCNIYA5-TXFO6AI";
        addresses = [ "tcp://toph:22000" ];
      };
      "bartleby" = {
        id = "OKG5G4Y-BJDA6GS-3G6XCCN-QZC6RIS-N7QDDS5-WL6MO2C-N74QD3S-YC5AIQ5";
        addresses = [ "tcp://bartleby:22000" ];
      };
      "diane" = {
        id = "D5TXPEW-4MFW7PA-4HANFUA-XU7ZTDJ-I7PUNHU-5EC4YSQ-AA46NZM-OX7VDAO";
        addresses = [ "tcp://diane:22000" ];
      };
    };

    settings.folders = {
      "share" = {
        id = "xa7yg-wn5qo";
        path = "/home/brandon/share";
        devices = [ "rosalind" "toph" "bartleby" "diane" ];
      };

      # "photos" = {
      #   id = "xa7yg-ph0to";
      #   type = "sendonly";
      #   path = "/var/lib/photoprism/originals";
      #   devices = [ "rosalind" "toph" "bartleby" "diane" ];
      # };

      "music" = {
        id = "xa7yg-mu5ic";
        type = "receiveonly";
        path = "/home/brandon/music";
        devices = [ "rosalind" "toph" "bartleby" "diane" ];
      };
    };
  };

  # Immich
  services.immich = {
    enable = true;
    port = 2283;
  };
}
