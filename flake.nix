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
      emacsWithOverrides = emacs.overrideAttrs (oldAttrs: rec {
        name = "emacs-${version}";
        version = "20230515.${substring 0 7 rev}";
        rev = "b5bfd808c6b40f47fdef8eb9986bc3127ca63c12"; # 2023-05-15T21:22:59+02:00


        src = pkgs.fetchFromGitHub {
          inherit rev;
          owner = "emacs-mirror";
          repo = "emacs";
          hash = "sha256-mcpHmOU4VvjKqlQeL/4/awyaPn7MLuHe+5fbhejXqNQ=";
        };
      });
      emacsWithPackages = (pkgs.emacsPackagesFor emacsWithOverrides).emacsWithPackages;
    in
    {
      packages.${system}.default = emacsWithPackages
        (epkgs: [ epkgs.vterm epkgs.pdf-tools ]);
    };
}
