{ config, pkgs, ... }:

{
  imports = [ ./bundles/sys-1-sat-32.nix ];

  # General
  system.stateVersion = "22.05";

  networking.hostName = "bartleby";
  networking.hostId = "1de212b7";
  networking.firewall.allowedTCPPorts = [ 22 ];

}
