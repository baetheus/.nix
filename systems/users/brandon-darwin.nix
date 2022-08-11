{ pkgs, ... }: {
  users.users.brandon = with pkgs; {
    packages = [ ripgrep ];
    shell = pkgs.zsh;
    home = "/Users/brandon";
  };
}
