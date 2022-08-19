let
  hopper = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH26soDnOC7jeIiaG65Vur93mFRbQipNZiWHd95ZF+TB brandon@hopper";
  rosalind = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJrUIIRoOgUoPZ17KzBE5MuI5kq/LvUnO7Sw3wVdbzhB brandon@rosalind";
  shared = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBajlplZeTASyUqnPJVrmkX3eyWT5I3JhwEWiDsV7NH1 brandon@null.pub";
  users = [ hopper rosalind shared ];
in
{
  "vaultwarden.age".publicKeys = users;
  "basicauth.age".publicKeys = users;
  "msmtp-passwordeval.age".publicKeys = users;
  "wifi-tuna.age".publicKeys = users;
  "k3s-token.age".publicKeys = users;
}
