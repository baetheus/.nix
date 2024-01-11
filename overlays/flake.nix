{
  description = "My Overlays";

  inputs = {
    jujutsu.url = "github:martinvonz/jj/v0.15.1";
  };

  outputs = { jujutsu, ... }: {
    overlays = {
      default = [
        jujutsu.overlays.default
      ];
    };
  };
}
