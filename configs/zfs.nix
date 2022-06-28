{ config, pkgs, ... }: {
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/";

  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;

  age.secrets.msmtp-passwordeval.file = ../secrets/msmtp-passwordeval.age;

  # Setup SMTP Relay
  programs.msmtp = {
    enable = true;
    setSendmail = true;
    defaults = {
      aliases = "/etc/aliases";
      port = 465;
      tls_trust_file = "/etc/ssl/certs/ca-certificates.crt";
      tls = "on";
      auth = "login";
      tls_starttls = "off";
    };
    accounts = {
      default = {
        host = "smtp.fastmail.com";
        passwordeval = "cat ${config.age.secrets.msmtp-passwordeval.path}";
        user = "noreply@null.pub";
        from = "noreply@null.pub";
      };
    };
  };

  # Tell zfs zed to use msmtp relay
  services.zfs.zed.settings = {
    ZED_DEBUG_LOG = "/tmp/zed.debug.log";
    ZED_EMAIL_ADDR = [ "brandon@null.pub" ];
    ZED_EMAIL_PROG = "${pkgs.msmtp}/bin/msmtp";
    ZED_EMAIL_OPTS = "-s '@SUBJECT@' @ADDRESS@'";

    ZED_NOTIFY_INTERVAL_SECS = 3600;
    ZED_NOTIFY_VERBOSE = true;

    ZED_USE_ENCLOSURE_LEDS = true;
    ZED_SCRUB_AFTER_RESILVER = true;
  };
  services.zfs.zed.enableMail = false;
}
