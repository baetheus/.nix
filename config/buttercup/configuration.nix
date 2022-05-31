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
      members = [ "plex" "media" ];
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
    user = "plex";
    group = "media";
    dataDir = "/media";
  };

  services.nzbget = {
    enable = true;
    user = "nzbget";
    group = "media";
    settings = rec {
      MainDir = "/var/lib/nzbget";
      DestDir = "${MainDir}/dst";
      InterDir = "${MainDir}/inter";
      NzbDir = "${MainDir}/nzb";
      QueueDir = "${MainDir}/queue";
      TempDir = "${MainDir}/tmp";
      ScriptDir = "${MainDir}/scripts";
      LockFile = "${MainDir}/nzbget.lock";
      LogFile = "/var/log/nzbget.log";
      WebDir = "/var/www/nzbget.null.pub";
      CertStore = "${pkgs.cacert}";

      # Easynews Europe
      "Server1.Active" = "yes";
      "Server1.Level" = "0";
      "Server1.Optional" = "no";
      "Server1.Group" = "0";
      "Server1.Host" = "secure-eu.news.easynews.com";
      "Server1.Port" = "443";
      "Server1.Username" = "user";
      "Server1.Password" = "pass";
      "Server1.JoinGroup" = "no";
      "Server1.Encryption" = "yes";
      "Server1.Connections" = "10";
      "Server1.Retention" = "5037";
      "Server1.IpVersion" = "ipv4";
      "Server1.Notes" = "Easynews European Secure Server";

      # Easynews USA
      "Server2.Active" = "yes";
      "Server2.Level" = "0";
      "Server2.Optional" = "no";
      "Server2.Group" = "0";
      "Server2.Host" = "secure-us.news.easynews.com";
      "Server2.Port" = "443";
      "Server2.Username" = "user";
      "Server2.Password" = "pass";
      "Server2.JoinGroup" = "no";
      "Server2.Encryption" = "yes";
      "Server2.Connections" = "10";
      "Server2.Retention" = "5037";
      "Server2.IpVersion" = "ipv4";
      "Server2.Notes" = "Easynews American Secure Server";
    };

  };
}
