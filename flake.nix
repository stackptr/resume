{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} ({
      self,
      config,
      withSystem,
      moduleWithSystem,
      ...
    }: {
      imports = [
        inputs.git-hooks-nix.flakeModule
      ];

      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];

      perSystem = {
        self',
        pkgs,
        inputs',
        config,
        ...
      }: {
        packages.resume =
          pkgs.runCommand "resume.pdf" {
            nativeBuildInputs = [pkgs.pandoc pkgs.texliveSmall];
            src = self;
          }
          ''
            set -eu
            pandoc "$src/README.md" -o "$out" --metadata-file="$src/meta.yml"
          '';
        packages.default = self'.packages.resume;

        devShells = {
          default = pkgs.mkShell {
            packages =
              [pkgs.just]
              ++ config.pre-commit.settings.enabledPackages;
            inherit (config.pre-commit) shellHook;
          };
        };

        formatter = let
          inherit (config.pre-commit.settings) package configFile;
        in
          pkgs.writeShellScriptBin "pre-commit-run" ''
            ${pkgs.lib.getExe package} run --all-files --config ${configFile}
          '';
        pre-commit.settings.hooks = {
          alejandra = {
            enable = true;
            args = [
              "--quiet"
            ];
          };
        };
      };

      flake = {
        nixConfig = {
          experimental-features = ["nix-command" "flakes"];
          extra-substituters = [
            "https://stackptr.cachix.org"
          ];
          extra-trusted-public-keys = [
            "stackptr.cachix.org-1:5e2q7OxdRdAtvRmHTeogpgJKzQhbvFqNMmCMw71opZA="
          ];
        };
      };
    });
}
