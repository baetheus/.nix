# Brandon's Nix Flake

I use nix flakes to manage laptop and server configurations,
my home environment, and my dotfiles (what precious few I use).

This repository is a monorepo containing any configurations or
extraneous packages I want to include in nix. I prefer a
[flakes](https://nixos.wiki/wiki/Flakes) only approach. Currently,
this repo only has system configurations for nix and darwin as well
as a simple home-manager configuration.

Since I'm used to flakes I am also leaning towards nix-direnv for
managing developer environments. You can expect a few templates to
land here in the long term as well as repackaged tools and devShells.

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

## System Configurations

These are my personal nix configuraions for:

- [nixos](https://github.com/NixOS)
- [nix-darwin](https://github.com/LnL7/nix-darwin)
- [home-manager](https://github.com/nix-community/home-manager)

I use home-manager as a module of nixos and nix-darwin. Since my systems
only have one user (me), there are a few utility functions in
[utils.nix](./utils.nix) for spinning up basic systems with minimal fuss.

### Darwin (macOS)

All of my darwin hosts get the same exact configurations with the only
differences being system architecture, hostname, username, and email address.
Defaults for these values can be found under `darwin` in
[defaults.nix](./defaults.nix).

### NixOS (Linux)

I strive to configure all of my linux hosts the same way up to the point
where their functional applications are concerned. Lately, considering the
small load on my servers, I opt for bare metal configurations over
virtualization or kubernetes clustering. In general, all linux hosts get
my [simple](./home/simple.nix) user config, some [common](./configs/common.nix)
and [linux](./configs/linux.nix) configurations, as well as [zfs](./configs/zfs.nix)
configurations. 

## Questions

If you got here and you have questions open the discussions and lets talk about
it! I'm very very new to nix but I'd love an opportunity to dig in some more.
