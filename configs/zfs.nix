{ config, nixpkgs, ... }: {
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/";

  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;

  # Requires zfs to be compiled with mail support
  services.zfs.zed.enableMail = true;
  services.zfs.zed.settings = {
    ZED_DEBUG_LOG = "/tmp/zed.debug.log";
    ZED_EMAIL_ADDR = [ "brandon@null.pub" ];
    ZED_EMAIL_OPTS = "-r 'noreply@null.pub' -s '@SUBJECT@' @ADDRESS@";

    ZED_NOTIFY_INTERVAL_SECS = 3600;
    ZED_NOTIFY_VERBOSE = true;

    ZED_USE_ENCLOSURE_LEDS = true;
    ZED_SCRUB_AFTER_RESILVER = true;
  };
}
