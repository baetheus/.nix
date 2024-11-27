{ pkgs, ... }: {
  system.stateVersion = 5;
  environment.systemPackages = with pkgs; [
    python311Full
    python311Packages.mypy
    mypy-protobuf
  ];
}
