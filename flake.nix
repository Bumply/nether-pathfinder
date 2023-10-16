{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
      flake-utils.lib.eachDefaultSystem(system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            binutils-unwrapped-all-targets
            clang_16
            pkg-config
            cmake
            ninja
            zig_0_9
          ];
          buildInputs = with pkgs; [
            gbenchmark
          ];

          shellHook = ''
            export NIX_CFLAGS_COMPILE="-march=native"
            export CC=${pkgs.clang_16}/bin/clang
            export CXX=${pkgs.clang_16}/bin/clang++
          '';
        };
      });
}
