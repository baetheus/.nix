{ config, pkgs, ... }:

{
  imports = [ ./bundles/sys-1-sat-32.nix ];

  # General
  system.stateVersion = "22.05";

  networking.hostName = "abigail";
  networking.hostId = "a9a768fa";
  networking.firewall.allowedTCPPorts = [ 22 80 443 ];

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
    };
  };

  # Headscale
  environment.systemPackages = with pkgs; [ headscale ];

  services.headscale = {
    enable = true;
    serverUrl = "https://net.null.pub";

    dns = {
      magicDns = true;
      nameservers = [ "1.1.1.1" ];
      domains = [ "null.pub" ];
      baseDomain = "null.pub";
    };
  };
}
