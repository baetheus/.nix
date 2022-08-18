{ config, pkgs, ... }:

{
  imports = [ ./bundles/sys-1-sat-32.nix ];

  # General
  system.stateVersion = "22.05";

  networking.hostName = "bubbles";
  networking.hostId = "e23f69c3";
  networking.firewall.allowedTCPPorts = [ 22 80 443 ];

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
    };
  };
}
