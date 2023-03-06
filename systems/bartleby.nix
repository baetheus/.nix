{ config, pkgs, ... }:

{
  imports = [ ./bundles/sys-1-sat-32.nix ];

  # General
  system.stateVersion = "22.05";

  networking.hostName = "bartleby";
  networking.hostId = "1de212b7";
  networking.firewall.allowedTCPPorts = [ 22 80 443 32400 ];

  # Secrets
  age.secrets.basicauth = {
    file = ../secrets/basicauth.age;
    owner = "nginx";
    group = "nginx";
  };

  age.secrets.miniflux = {
    file = ../secrets/miniflux-config.age;
  };

  # Users and Groups
  users = {
    users.media = {
      group = "media";
      isSystemUser = true;
    };
    groups.media = {
      members = [ "media" ];
    };
  };

  # Nginx
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "admin@null.pub";

  services.nginx = {
    enable = true;

    virtualHosts = {
      "bartleby.null.pub" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          root = "/var/www/bartleby.null.pub";
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

      "nzbget.null.pub" = {
        forceSSL = true;
        enableACME = true;
        basicAuthFile = config.age.secrets.basicauth.path;
        locations."/" = {
          proxyPass = "http://0.0.0.0:6789";
          proxyWebsockets = true;
        };
      };

      "series.null.pub" = {
        forceSSL = true;
        enableACME = true;
        basicAuthFile = config.age.secrets.basicauth.path;
        locations."/" = {
          proxyPass = "http://0.0.0.0:8989";
          proxyWebsockets = true;
        };
      };

      "movies.null.pub" = {
        forceSSL = true;
        enableACME = true;
        basicAuthFile = config.age.secrets.basicauth.path;
        locations."/" = {
          proxyPass = "http://0.0.0.0:7878";
          proxyWebsockets = true;
        };
      };

      "music.null.pub" = {
        forceSSL = true;
        enableACME = true;
        basicAuthFile = config.age.secrets.basicauth.path;
        locations."/" = {
          proxyPass = "http://0.0.0.0:8686";
          proxyWebsockets = true;
        };
      };

      "reader.null.pub" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://0.0.0.0:8080";
          proxyWebsockets = true;
        };
      };
    };
  };

  # Media Services
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

  services.sonarr = {
    enable = true;
    user = "media";
    group = "media";
  };

  services.radarr = {
    enable = true;
    user = "media";
    group = "media";
  };

  services.lidarr = {
    enable = true;
    user = "media";
    group = "media";
  };

  services.miniflux = {
    enable = true;
    adminCredentialsFile = config.age.secrets.miniflux.path;
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
    devices = {
      "rosalind" = {
        id = "FU4DRZY-65RNCNZ-CDJXQOS-V2PKRY2-ULGBH4J-Q5AA7GC-WNQ3JFP-PLB6MQW";
        addresses = [ "tcp://rosalind:22000" ];
        autoAcceptFolders = true;
        introducer = true;
      };
    };
  };
}
