{ pkgs, ... }: {
  # Standardize on California time
  time.timeZone = "America/Los_Angeles";

  # Make sure we have the tools to troubleshoot available to root
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    ripgrep
    darkhttpd
    syncthing
  ];

  # Configure nix for all the fun stuff
  nix = {
    package = pkgs.nixStable;

    settings = {
      trusted-users = [ "@wheel" ];
      substituters = [
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];

      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
    };

    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };
}
