{ config, pkgs, ... }:

{
  imports = [ ./bundles/sys-1-sat-32.nix ];

  # General
  system.stateVersion = "22.05";

  networking.hostName = "bubbles";
  networking.hostId = "e23f69c3";
  networking.firewall.allowedTCPPorts = [ 22 80 443 3389 ];

  # Secrets
  # age.secrets.vaultwarden.file = ../secrets/vaultwarden.age;

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

      # "vault.null.pub" = {
      # forceSSL = true;
      # enableACME = true;
      # locations."/" = {
      # proxyPass = "http://0.0.0.0:8000";
      # };
      # locations."/notifications/hub" = {
      # proxyPass = "http://0.0.0.0:3012";
      # proxyWebsockets = true;
      # };
      # };
    };
  };

  # Provides a private bitwarden server
  # services.vaultwarden = {
  # enable = true;
  # config = {
  # DOMAIN = "https://vault.null.pub";
  # WEBSOCKET_ENABLED = "true";
  # SMTP_HOST = "smtp.fastmail.com";
  # SMTP_FROM = "noreply@null.pub";
  # SMTP_FROM_NAME = "Vaultwarden";
  # SMTP_PORT = "465";
  # SMTP_SSL = "true";
  # SMTP_EXPLICIT_SSL = "true";
  # };
  # environmentFile = config.age.secrets.vaultwarden.path;
  # };

  # Backs up non-nix files to blossom
  # services.zfs.autoReplication = {
  # enable = true;
  # recursive = true;
  # followDelete = true;
  # host = "blossom.nll.sh";
  # username = "brandon";
  # identityFilePath = "/keys/id_ed25519_shared";
  # localFilesystem = "pool/root";
  # remoteFilesystem = "pool/backup/bubbles/root";
  # };
}
