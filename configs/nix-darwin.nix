{ pkgs, ... }: {
  # Nix
  nix = {
    binaryCaches = [
      "https://cache.nixos.org/"
    ];

    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];

    package = pkgs.nixUnstable;

    trustedUsers = [ "@wheel" ];

    extraOptions = ''
      experimental-features = nix-command flakes
      auto-optimise-store = true
      keep-outputs = true
      keep-derivations = true
    '';
  };
}
