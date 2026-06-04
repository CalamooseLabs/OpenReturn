{
  description = "API backend for 990 Automation & Evaluation.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    zed-editor = {
      url = "github:CalamooseLabs/antlers/flakes.zed-editor?dir=flakes/zed-editor";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ...} @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      system = system;
      config.allowUnfree = true;
    };
    openreturn = pkgs.callPackage ./build.nix {};
  in {
    devShells.${system}.default = import ./shell.nix {
      inherit pkgs;
      inherit inputs;
    };

    packages.${system}.default = openreturn;

    apps.${system}.default = {
      type = "app";
      program = "${openreturn}/bin/openreturn";
    };

    nixosModules.default = import ./module.nix;
  };
}
