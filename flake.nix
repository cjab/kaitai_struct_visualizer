{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        ruby = pkgs.ruby;
        jre = pkgs.jre8;
        gems = pkgs.bundlerEnv {
          inherit ruby;
          name = "kaitai-struct-visualizer-env";
          gemfile = ./Gemfile;
          lockfile = ./Gemfile.lock;
          gemset = ./gemset.nix;
        };
        devDependencies = with pkgs; [ direnv bundix ];
        runtimeDependencies = [ ruby gems jre ];
      in
      rec {
        devShell = with pkgs;
          mkShell {
            buildInputs = runtimeDependencies ++ devDependencies;
          };
      });
}
