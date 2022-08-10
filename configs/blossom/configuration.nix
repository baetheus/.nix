{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # General
  system.stateVersion = "22.05";

  networking.hostName = "blossom";
  networking.hostId = "5be573ce";
  networking.firewall.allowedTCPPorts = [ 22 443 ];

  # Secrets
  # age.secrets.vaultwarden.file = ../../secrets/vaultwarden.age;

  # Nginx
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "admin@null.pub";

  # Headscale
  services.headscale = {
    enable = true;
    address = "0.0.0.0";
    port = 443;
    serverUrl = "https://blossom.null.pub";
    tls.letsencrypt.hostname = "blossom.null.pub";

    dns = {
      nameservers = [ "1.1.1.1" ];
      domains = [ "null.internal" ];
      magicDns = true;
      baseDomain = "null.internal";
    };
  };
}
