{
  description = "Harsh's macOS CLI setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
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
          home-manager.darwinModules.home-manager
          {
            nixpkgs.config.allowUnfree = true;
            nix.enable = false;

            system.primaryUser = "harshsharma";
            system.stateVersion = 7;

            users.users.harshsharma.home = "/Users/harshsharma";

            homebrew = {
              enable = true;
              taps = [
                "siddharthvaddem/openscreen"
                "rakalex/mac-brightnessctl"
              ];
              brews = [
                "cliclick"
                "mac-brightnessctl"
              ];
              casks = [
                "openscreen"
              ];
            };

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
