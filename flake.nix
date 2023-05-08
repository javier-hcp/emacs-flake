{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "aarch64-darwin"; # builtins.currentSystem
      pkgs = nixpkgs.legacyPackages.${system};
      substring = nixpkgs.lib.strings.substring;
      emacs = pkgs.emacs.override {
        srcRepo = true;
        withWebP = true;
        withPgtk = true;
        withSQLite3 = true;
        withTreeSitter = true;
        withImageMagick = false;
      };
    in
    {
      packages.${system}.default = emacs.overrideAttrs (oldAttrs: rec {
        name = "emacs-${version}";
        version = "20230320.${substring 0 7 rev}";
        rev = "786de66ec3c4cff90cafd0f8a68f9bce027e9947"; # 2023-03-20T09:17:47-05:00

        src = pkgs.fetchFromGitHub {
          inherit rev;
          owner = "emacs-mirror";
          repo = "emacs";
          hash = "sha256-mcpHmOU4VvjKqlQeL/4/awyaPn7MLuHe+5fbhejXqNQ=";
        };
      });
    };
}
