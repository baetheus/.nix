{ me, pkgs, ... }: {
  programs.jujutsu = with me; {
    enable = true;
    package = pkgs.jujutsu;
    settings = {
      user.name = name;
      user.email = email;
      signing = {
        behavior = "own";
        backend = "ssh";
        key = "~/.ssh/id_ed25519_sk_rk_default.pub";
      };

      aliases = {
        dlog = ["log" "-r"];
        l = ["log" "-r" "(trunk()..@):: | (trunk()..@)-"];
        fresh = ["new" "trunk()"];
        tug = [
            "bookmark"
            "move"
            "--from"
            "closest_bookmark(@)"
            "--to"
            "closest_pushable(@)"
        ];
      };

      "revset-aliases" = {
        "closest_bookmark(to)" = "heads(::to & bookmarks())";
        "closest_pushable(to)" = "heads(::to & mutable() & ~description(exact:\"\") & (~empty() | merges()))";
        "desc(x)" = "description(x)";
        "pending()" = ".. ~ ::tags() ~ ::remote_bookmarks() ~ @ ~ private()";
        "private()" = "description(glob:'wip:*') | \
            description(glob:'private:*') | \
            description(glob:'WIP:*') | \
            description(glob:'PRIVATE:*') | \
            conflicts() | \
            (empty() ~ merges()) | \
            description('substring-i:\"DO NOT MAIL\"')";
      };
    };
  };
}
