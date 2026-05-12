{
  description = "API backend for 990 Automation.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    zed-editor = {
      url = "github:CalamooseLabs/antlers/flakes.zed-editor?dir=flakes/zed-editor";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ...} @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {system = system;};
    ffapi = pkgs.callPackage ./build.nix {};
  in {
    devShells.${system}.default = import ./shell.nix {
      inherit pkgs;
      inherit inputs;
    };

    packages.x86_64-linux.default = ffapi;

    apps.default = {
      type = "app";
      program = "${ffapi}/bin/ffapi";
    };
  };
}
