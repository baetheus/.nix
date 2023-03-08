let
  keychain-a = "age1yubikey1q0w4elvpyp83lnat0hce5247rvuvmjnx2d670t0qp07447rxqyulx7tpv2r";
  folder-b = "age1yubikey1qwqyr54w5yseu8lwusqr9tvxm8e30tv7mn3xf4swjaq6r383985k5t7fp3y";
  laptop-c = "age1yubikey1qf95j5rtmv2tunv0a4f2qecnej37zsegy840g38aq5hvzcehv2d6jqpyvzw";
  shared = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBajlplZeTASyUqnPJVrmkX3eyWT5I3JhwEWiDsV7NH1 brandon@null.pub";
  all = [ keychain-a folder-b laptop-c shared ];
in
{
  "vaultwarden.age".publicKeys = all;
  "basicauth.age".publicKeys = all;
  "msmtp-passwordeval.age".publicKeys = all;
  "wifi-tuna.age".publicKeys = all;
  "k3s-token.age".publicKeys = all;
  "innernet-config.age".publicKeys = all;
  "miniflux-config.age".publicKeys = all;
  "photoprism.age".publicKeys = all;
}
