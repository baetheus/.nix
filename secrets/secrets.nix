let
  brandon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH26soDnOC7jeIiaG65Vur93mFRbQipNZiWHd95ZF+TB brandon@neumann";
  users = [ brandon ];
in
{
  "vaultwarden.age".publicKeys = users;
}
