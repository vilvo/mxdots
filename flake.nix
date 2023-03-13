# SPDX-License-Identifier: MIT
{
  description = "dotfile for NixOS on M1";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, apple-silicon, ... } :
  let
    system = "aarch64-linux";
    inherit (nixpkgs.lib) nixosSystem;
    nixpkgsArgs = {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations."blub" = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit system nixpkgs; };
      modules = [
	./hardware-configuration.nix
	apple-silicon.nixosModules.apple-silicon-support
	./configuration.nix
      ];
    };
  };
}
