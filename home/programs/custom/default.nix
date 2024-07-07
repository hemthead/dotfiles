{ pkgs, ... }: { home.packages = [ (pkgs.callPackage ./do-rebuild.nix { }) ]; }
