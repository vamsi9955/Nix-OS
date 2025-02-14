{ config, pkgs, ... }:

{
  home.packages = [
    (pkgs.flameshot.overrideAttrs (old: rec {
      cmakeFlags = (old.cmakeFlags or []) ++ [
        "-DUSE_WAYLAND_CLIPBOARD=true"
        # If you want to try grim integration instead, you can uncomment the next line:
         "-DUSE_WAYLAND_GRIM=true"
      ];
      
    }))
  ];
}
