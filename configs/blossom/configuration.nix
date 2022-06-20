{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # General
  system.stateVersion = "22.05";

  networking.hostName = "blossom";
  networking.hostId = "5be573ce";
  networking.firewall.allowedTCPPorts = [ 22 ];

  # Secrets
  # age.secrets.vaultwarden.file = ../../secrets/vaultwarden.age;

  # Nginx
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "admin@null.pub";

  # services.nginx = {
  #   enable = true;

  #   virtualHosts = {
  #     "bubbles.nll.sh" = {
  #       forceSSL = true;
  #       enableACME = true;
  #       locations."/" = {
  #         root = "/var/www/bubbles.nll.sh";
  #         extraConfig = "autoindex on;";
  #       };
  #     };
  #   };
  # };

}
