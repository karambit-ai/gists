{
  description = "karambit-ai/gdrive development flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in with pkgs; {
        devShell = pkgs.mkShell {
          buildInputs = [
            curl
            git
            libreoffice
            magic-wormhole
            pandoc
            R
            rclone
            rPackages.officedown
          ];

          shellHook = ''
            [[ ! -f pagebreak.lua ]] && curl -O https://raw.githubusercontent.com/pandoc-ext/pagebreak/main/pagebreak.lua
          '';
        };
      });
}
