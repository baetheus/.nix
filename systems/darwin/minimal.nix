{ pkgs, ... }: {
  # Users
  nix.configureBuildUsers = true;

  # Services
  services.nix-daemon.enable = true;

  # Programs
  programs.zsh.enable = true;

  # Packages
  environment.systemPackages = with pkgs; [
    git
    vim
    tailscale
    openssh
  ];

  # System
  system = {
    defaults = {
      NSGlobalDomain = {
        AppleMetricUnits = 1;
        AppleMeasurementUnits = "Centimeters";
        AppleTemperatureUnit = "Celsius";
        AppleShowScrollBars = "Automatic";
        AppleFontSmoothing = 2;
        AppleShowAllExtensions = true;
        NSScrollAnimationEnabled = true;
        PMPrintingExpandedStateForPrint = true;

        "com.apple.sound.beep.feedback" = 0;
        "com.apple.sound.beep.volume" = "0.4723665";
        "com.apple.springing.enabled" = false;
        "com.apple.swipescrolldirection" = false;
        "com.apple.trackpad.scaling" = "2.0";
      };

      SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;

      alf = {
        globalstate = 1;
        allowsignedenabled = 1;
        allowdownloadsignedenabled = 1;
        stealthenabled = 1;
      };

      dock = {
        autohide = true;
        expose-group-by-app = false;
        mru-spaces = false;
        tilesize = 32;
        showhidden = true;
        # Disable all hot corners
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
      };

      finder = {
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
      };

      loginwindow = {
        GuestEnabled = false;
        DisableConsoleAccess = false;
        SHOWFULLNAME = true;
      };

      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = true;
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };
}
