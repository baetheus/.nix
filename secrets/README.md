# Agenix Secrets

This directory contains things too precious to publish on the open web.
It's mainly configuration files, credentials, secret network topologies
etc.

I run a simple infrastructure, there are my yubikey piv identites
and a shared ssh keypair. All of these are used to encrypt the secrets.

As of September 2022 to edit/add a yubikey identity one must use
[age-plugin-yubikey](https://github.com/str4d/age-plugin-yubikey) to
generate/list the identity stub and public key for the identity. For
simplicity I keep the identities here under [identities](./identities).
