{ pkgs }:

{
  dotfiles = import ./dotfiles { inherit pkgs; };
}
