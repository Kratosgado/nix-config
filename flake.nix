{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rustowl-flake.url = "github:nix-community/rustowl-flake";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    snapd = {
      url = "github:nix-community/nix-snapd";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self, snapd, nixpkgs, rustowl-flake, home-manager, ... }:
    let
      user = "kratosgado";
      userDescription = "Kratosgado";
      hostName = "nixos";
    in {
      nixosConfigurations.${hostName} = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit user userDescription hostName; };
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          snapd.nixosModules.default
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${user} = import ./home.nix;
              backupFileExtension = "backup";
              extraSpecialArgs = { inherit inputs user; };
            };
          }
        ];
      };
    };
}
