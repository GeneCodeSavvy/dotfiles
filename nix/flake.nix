{
  description = "Harsh's macOS CLI setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }:
    let
      system = "aarch64-darwin"; # Apple Silicon Mac
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      darwinConfigurations.harshsharma = inputs.nix-darwin.lib.darwinSystem {
        inherit system;

        modules = [
          inputs.nix-homebrew.darwinModules.nix-homebrew
          home-manager.darwinModules.home-manager
          {
            nixpkgs.config.allowUnfree = true;
            nix.enable = false;

            nix-homebrew = {
              enable = true;
              user = "harshsharma";
            };

            homebrew = {
              enable = true;
              casks = [
                "opensuperwhisper"
              ];
            };

            system.primaryUser = "harshsharma";
            system.stateVersion = 7;

            users.users.harshsharma.home = "/Users/harshsharma";

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.harshsharma = import ./home.nix;
          }
        ];
      };

      homeConfigurations.harshsharma = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./home.nix
        ];
      };
    };
}
