{
  description = "CHANGE ME";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/release-25.05";
  inputs.utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs { inherit system; };
      mkScript = pkgs.writeShellScriptBin;

      shell = with pkgs; mkShell {
        packages = [
          # Insert packages here

          # Insert shell aliases here
          (mkScript "hello" ''echo $SOME_ENV_VAR'')
        ];

        shellHook = ''
          export SOME_ENV_VAR="Hello World"
        '';
      };
    in {
      devShells.default = shell;
    });
}

