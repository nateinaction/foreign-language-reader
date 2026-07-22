{
  description = "Foreign Language Reader dev environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        isDarwin = pkgs.stdenv.isDarwin;
        darwinTools = with pkgs; [
          xcodegen
          swiftformat
          swiftlint
        ];
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            git
          ] ++ (if isDarwin then darwinTools else [ ]);

          shellHook = ''
            if [ "$(uname)" != "Darwin" ]; then
              echo "Note: xcodegen/swiftformat/swiftlint/xcodebuild require macOS + Xcode."
              echo "This shell provides repo tooling only; open/build the project on a Mac."
            fi
          '';
        };
      });
}
