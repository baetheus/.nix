{ pkgs, ... }: {
  # Minimal Config
  time.timeZone = "America/Los_Angeles";
  environment.systemPackages = with pkgs; [ vim wget git zellij ];
}
