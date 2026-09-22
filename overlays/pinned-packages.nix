self: super:
let
  pinnedNixpkgs = import (builtins.fetchGit {
    url = "https://github.com/NixOS/nixpkgs";
    rev = "8eaee110344796db060382e15d3af0a9fc396e0e";
  });
in {
  android-studio = pinnedNixpkgs.android-studio;
  jetbrains = super.jetbrains // {
    idea-community = pinnedNixpkgs.jetbrains.idea-community;
  };
}

