# Nix System Configurations

These are my personal nix configuraions. Right now there are only
[nix-darwin](https://github.com/LnL7/nix-darwin) and
[home-manager](https://github.com/nix-community/home-manager). There will be
some nixos configurations here, and hopefully some nixops stuff. However, I'm
just not sure how to organize that stuff yet.

## Installation

1. Clone this into `~/.nix` or some similar place and `cd` into it.
2. Install [nix](https://nixos.org/download.html).
3. You'll probably have to enable nix flakes.

```sh
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

4. Build the initial activation for your `HOST` and then switch to it.

```sh
nix build .#darwinConfigurations.HOST.system
./result/sw/bin/darwin-rebuild switch --flake .
```

## Questions

If you got here and you have questions open the discussions and lets talk about
it! I'm very very new to nix but I'd love an opportunity to dig in some more.
