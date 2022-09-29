# Profiles

# This is a collection of "me" configurations
# that can be used to setup user configurations
# in systems and homes.
{
  # My standard profile
  brandon = {
    username = "brandon";
    name = "Brandon Blaylock";
    email = "brandon@null.pub";
    signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKApq/9Vfhbk1M5wu0XmnajPCl/KlrL4bW6llSjReniR";
    keys = [
      # Keychain Yubkey A
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIAetuhFZ8SCOLnYdfZOCFTQLzIh3a25WX991X5aWem5eAAAAC3NzaDpkZWZhdWx0 brandon@rosalind"
      # Folder Yubikey B
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIO1pi4MnWUTF2w9GBbxk7F5uuYmt+uRA7gKMGuKqeQe3AAAAC3NzaDpkZWZhdWx0 brandon@rosalind"
      # Laptop Yubikey C
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIL7W3Bg5SHwsLQqOjL3lQWf2F9zqY19g9MusuKXi93VtAAAAC3NzaDpkZWZhdWx0 brandon@rosalind"
    ];
  };

  # My work profile
  brandonblaylock = {
    username = "brandonblaylock";
    name = "Brandon Blaylock";
    email = "bblaylock@cogility.com";
    signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGmvOAVOtZWsucJnuEUGAw05MB11AOxgLtCmjRg5fY6u bblaylock@cogility.com";
    keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGmvOAVOtZWsucJnuEUGAw05MB11AOxgLtCmjRg5fY6u bblaylock@cogility.com"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIAetuhFZ8SCOLnYdfZOCFTQLzIh3a25WX991X5aWem5eAAAAC3NzaDpkZWZhdWx0 brandon@rosalind"
    ];
  };
}
