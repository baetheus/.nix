{ agenix, ... }: {
  # We expect flakes to be added via extraArgs in
  # nixosSystem
  import = [ agenix.nixosModule ];
  age.identityPaths = [ "/keys/id_ed25519_shared" ];
}
