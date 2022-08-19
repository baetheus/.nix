{ pkgs, ... }: {
  # Minimal Config
  time.timeZone = "America/Los_Angeles";
  environment.systemPackages = with pkgs; [ darkhttpd vim wget git zellij ];
}
