{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # General
  system.stateVersion = "22.05";

  networking.hostName = "bubbles";
  networking.hostId = "e23f69c3";
  networking.firewall.allowedTCPPorts = [ 22 80 443 3389 ];

  # Secrets
  age.secrets.vaultwarden.file = ../../secrets/vaultwarden.age;

  # Nginx
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "admin@null.pub";

  services.nginx = {
    enable = true;

    virtualHosts = {
      "bubbles.nll.sh" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          root = "/var/www/bubbles.nll.sh";
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

  # Services
  services.vaultwarden = {
    enable = true;
    config = {
      DOMAIN = "https://vault.null.pub";
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

  # Containers
  containers.remote =
    {
      autoStart = true;
      config = { config, pkgs, ... }: {
        system.stateVersion = "22.05";

        imports = [ ../users.nix ];


        services.xserver = {
          enable = true;

          desktopManager = {
            xterm.enable = false;
          };

          displayManager = {
            defaultSession = "none+i3";
          };

          windowManager.i3 = {
            enable = true;
            extraPackages = with pkgs; [
              dmenu #application launcher most people use
              i3status # gives you the default i3 status bar
              i3lock #default i3 screen locker
              i3blocks #if you are planning on using i3blocks over i3status
              firefox
            ];
          };
        };

        services.xrdp.enable = true;
        services.xrdp.defaultWindowManager = "i3";
        services.xrdp.openFirewall = true;
      };
    };
}
