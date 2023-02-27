{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-old.url = "github:NixOS/nixpkgs?rev=0e6945185b65ed6a163501d66420f8a16e49e4c3";
  };

  outputs = inputs @ { self, ... }:
    (inputs.flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let

        pkgs = import inputs.nixpkgs {
          inherit system;
        };

        pkgs-old = import inputs.nixpkgs-old {
          inherit system;
        };

        pkgs-old-old = import inputs.nixpkgs-old-old {
          inherit system;
        };

        eqty.pkgs = inputs.eqty-nix.packages.${system};

        commonPkgs = with pkgs; [
          just
        ];

        nodeAndYarn = nodejs: [ nodejs (pkgs.yarn.override { inherit nodejs; }) ];

        nodeAndYarn16 = nodeAndYarn pkgs.nodejs-16_x;
        nodeAndYarn12 = nodeAndYarn pkgs-old.nodejs-12_x;

      in
      rec {

        devShells = {
          default = pkgs.mkShell {
            buildInputs = commonPkgs ++ nodeAndYarn16;
          };
          node16 = pkgs.mkShell {
            buildInputs = commonPkgs ++ nodeAndYarn16;
          };
          node12 = pkgs.mkShell {
            buildInputs = commonPkgs ++ nodeAndYarn12;
          };
        };

      }));
}
