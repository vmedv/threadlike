
{
  description = "C++ Template";

  inputs = {
    nixpkgs.url = "nixpkgs";
    systems.url = "github:nix-systems/x86_64-linux";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      
      mkShell = compilerStdenv: pkgs.mkShell {
        NIX_ENFORCE_PURITY = 1;
        
        nativeBuildInputs = with pkgs; [
          cmake
          pkg-config
          clang-tools
          gdb
        ] ++ [
          compilerStdenv.cc
          compilerStdenv.cc.bintools
        ];

        buildInputs = with pkgs; [
        ];

        shellHook = ''
          alias ls=${pkgs.eza}/bin/eza
          alias ll="${pkgs.eza}/bin/eza -l --git --icons"
          alias cat=${pkgs.bat}/bin/bat

          echo "Environment ready with:"
          echo "- CC: $(which $CC)"
          echo "- CXX: $(which $CXX)"
          echo "- - compiler version: $($CC --version | head -n1)"
          echo "- Developer tools: atuin, eza, bat, fzf"
        '';
      };

    in {
      devShells = {
        gcc = mkShell pkgs.gcc14Stdenv;
        clang = mkShell pkgs.llvmPackages_19.stdenv;
        default = self.devShells.${system}.clang;
      };

      packages.default = pkgs.stdenv.mkDerivation {
        pname = "threadlike";
        version = "0.0.1";
        src = ./.;
        shell = mkShell pkgs.gcc14Stdenv;
        nativeBuildInputs = self.shell.nativeBuildInputs;
        buildInputs = self.shell.buildInputs;
      };
    });
}
