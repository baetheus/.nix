let
  brandon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH26soDnOC7jeIiaG65Vur93mFRbQipNZiWHd95ZF+TB brandon@neumann";
  shared = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBajlplZeTASyUqnPJVrmkX3eyWT5I3JhwEWiDsV7NH1 brandon@null.pub";
  users = [ brandon shared ];
in
{
  "vaultwarden.age".publicKeys = users;
}
