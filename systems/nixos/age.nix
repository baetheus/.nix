{ ... }: {
  # We expect flakes to be added via extraArgs in
  # nixosSystem
  age.identityPaths = [ "/keys/id_ed25519_shared" ];
}
