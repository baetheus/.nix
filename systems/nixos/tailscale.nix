{ pkgs, ... }: {
  services.tailscale.enable = true;
  environment.systemPackages = with pkgs; [ tailscale ];

  # Allow package forwarding
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = 1;

  networking.firewall.checkReversePath = "loose";
}
