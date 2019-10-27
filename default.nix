{ pkgs ? import <nixpkgs> { } }:

{
  lib = import ./lib { inherit pkgs; };
  nerd-font-symbols = pkgs.callPackage ./pkgs/nerd-font-symbols { };
}
