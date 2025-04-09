{ config, pkgs, ... }:

{
  imports = [ ./bundles/sys-1-sat-32.nix ];

  # General
  system.stateVersion = "22.05";

  networking.hostName = "bartleby";
  networking.hostId = "1de212b7";
  networking.firewall.allowedTCPPorts = [ 22 80 443 32400 ];
  networking.firewall.allowedUDPPorts = [ 41641 ]; # Tailscale

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

      "media.null.pub" = {
        forceSSL = true;
        enableACME = true;
        basicAuthFile = config.age.secrets.basicauth.path;
        locations."/" = {
          root = "/media";
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
          proxyWebsockets = true; };
      };

      "series.null.pub" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://0.0.0.0:8989";
          proxyWebsockets = true;
        };
      };

      "movies.null.pub" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://0.0.0.0:7878";
          proxyWebsockets = true;
        };
      };

      "music.null.pub" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://0.0.0.0:8686";
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
      "abigail" = {
        id = "5HMRD3B-UWFLIFC-XDY2NPO-TVWGA2U-GB5H2CT-FUFWNDB-OTKAGEQ-JGLF5QF";
        addresses = [ "tcp://abigail:22000" ];
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
        devices = [ "rosalind" "toph" "abigail" "diane" ];
      };

      "photos" = {
        id = "xa7yg-ph0to";
        type = "receiveonly";
        path = "/home/brandon/photos";
        devices = [ "rosalind" "toph" "abigail" "diane" ];
      };

      "music" = {
        id = "xa7yg-mu5ic";
        type = "sendonly";
        path = "/media/music";
        devices = [ "rosalind" "toph" "abigail" "diane" ];
      };
    };
  };

}
