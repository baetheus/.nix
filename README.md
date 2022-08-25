# Brandon's Nix Flake

I use nix flakes to manage laptop and server configurations,
my home environment, and my dotfiles (what precious few I use).

This repository is a monorepo containing any configurations or
extraneous packages I want to include in nix. I prefer a
[flakes](https://nixos.wiki/wiki/Flakes) only approach.

Since I'm used to flakes I am also leaning towards nix-direnv for
managing developer environments. You can expect a few templates to
land here in the long term as well as repackaged tools and devShells.

## Installation (darwin)

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

## Installation (nixos)

1. Fork this repository.
2. Create a system configuration in [systems/default.nix](./systems/default.nix).
3. Push your changes to your repo.
4. Install or rebuild with the following commands.

If you are already on nixos:

```sh
nixos-rebuild switch --flake github:YOUR_REPO_PATH#YOUR_HOST_NAME
````

If you are installing via kexec or somesuch

```sh
nixos-install --flake github:YOUR_REPO_PATH#YOUR_HOST_NAME --root /YOUR_ROOT_MOUNT
````

## System Configurations

These are my personal nix configuraions for:

- [nixos](https://github.com/NixOS)
- [nix-darwin](https://github.com/LnL7/nix-darwin)
- [home-manager](https://github.com/nix-community/home-manager)

I use home-manager as a module of nixos and nix-darwin. Broadly, I use the built in
abstractions of home-manager, nix-darwin, and nixos as much as possible for
configuration. Following is the current structure and purposes of various
directories and files.

```
.
├── flake.nix # Default entrypoint for .nix
├── homes # Contains all configuration related to home-manager
│   ├── default.nix # Takes flake inputs and returns home-manager module configs by user
│   ├── profiles.nix # Various user specific profiles: name, email, username, etc
│   ├── bundles # Home Manager configurations that reference ../modules
│   └── modules # Program or service specific home-manager configurations
├── packages # Not used yet, but will be nixified packges
│   ├── flake.lock
│   └── flake.nix
├── scripts # Scripts related to nix
│   └── run.sh # Creates zfs pools for use with nixos installation
├── secrets # Age encrypted secrets
└── systems # Contains all configuration related to nixos and nix-darwin
    ├── default.nix # Takes flake inputs and returns nixos and darwin configs by system
    ├── bundles # @deprecated Configuration bundles
    ├── common # Configuration modules common to nixos and darwin
    ├── darwin # Configuration modules specific to darwin
    ├── hardware # Harware specific configuration settings
    ├── nixos # Configuration modules specific to nixos
    └── users # @deprecated User specific configurations
```

As I learn more about nix I simplify my configurations here. Once I've gone a few months
to a year without changing the structure I intend to add instructions on how and why
this particular organization works.

## Questions

If you got here and you have questions open the discussions and lets talk about
it! I'm very very new to nix but I'd love an opportunity to dig in some more.
