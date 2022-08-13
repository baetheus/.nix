{ config, pkgs, ... }:

{
  imports = [ ./bundles/sys-1-sat-32.nix ];

  # General
  system.stateVersion = "22.05";

  networking.hostName = "abigail";
  networking.hostId = "a9a768fa";
  networking.firewall.allowedTCPPorts = [ 22 ];

  # Nginx
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "admin@null.pub";

  # Headscale
  services.headscale = {
    enable = true;
    address = "0.0.0.0";
    port = 443;
    serverUrl = "https://net.null.pub";
    tls.letsencrypt.hostname = "net.null.pub";

    dns = {
      magicDns = true;
      nameservers = [ "1.1.1.1" ];
      domains = [ "null.internal" ];
      baseDomain = "null.internal";
    };
  };
}
