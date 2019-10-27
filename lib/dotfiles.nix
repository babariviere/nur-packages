# This package contains a set of functions to generate dotfiles.
{ pkgs }:

with pkgs;

let
  submoduleP = n: v:
    v == "regular" && (lib.strings.hasSuffix ".nix" n) && n != "default.nix"
    && n != "options.nix";

  generateOptionsSubmodules = with lib;
    mpath:
    mapAttrs' (file: value:
      let name = removeSuffix ".nix" file;
      in {
        name = name;
        value = mkOption {
          type =
            types.submodule { options = { enable = mkEnableOption name; }; };
          # TODO: description
          default = { };
        };
      }) (filterAttrs submoduleP (builtins.readDir mpath));
in {
  # warning: this does not support path with depth > 1
  # [path] -> set
  generateOptions = with lib;
    imports:
    foldl (m: path:
      let
        optionsPath = path + ./options.nix;
        extraOptions =
          if builtins.pathExists optionsPath then import optionsPath else { };
        name = builtins.baseNameOf path;
      in m // {
        "${name}" = mkOption {
          type = types.submodule {
            options = (generateOptionsSubmodules path) // extraOptions;
          };
          description = name + " submodule.";
          # TODO: find a way to add description.
          default = { };
        };
      }) { } imports;
}
