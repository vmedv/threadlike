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

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        mkShell =
          compilerStdenv:
          pkgs.mkShell {
            NIX_ENFORCE_PURITY = 1;

            nativeBuildInputs =
              with pkgs;
              [
                cmake
                pkg-config
                clang-tools
                gdb
                autoconf
                automake
                libtool

                eza
                bat
              ]
              ++ [
                compilerStdenv.cc
                compilerStdenv.cc.bintools
              ];

            buildInputs = with pkgs; [
              boost
              openssl
            ];

            shellHook = ''
              alias ls=${pkgs.eza}/bin/eza
              alias ll="${pkgs.eza}/bin/eza -l --git --icons"
              alias cat=${pkgs.bat}/bin/bat

              export PROMPT_SPACE="thrlik"

              clear
            '';
          };

      in
      {
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
      }
    );
}
