{ pkgs, ... }: {
  users.users.brandon = {
    shell = pkgs.zsh;
  };
}
