{ config, pkgs, inputs, ... }:
let
  ax-shell = pkgs.fetchFromGitHub {
        owner = "maotseantonio";
        repo = "Ax-Shell";
        rev = "2af353feb50edcb1fddf3477a51d861e5b1c1fa5";
        hash = "sha256-2qyXOBTsm7oo1FJgCu5+E2X+wyr/kpVB+SlvhvzwOIM=";    
    };
   
in
{
  home.file."${config.xdg.configHome}/Ax-Shell" = {
    source = ax-shell;
  };

  home.file.".local/share/fonts/tabler-icons.ttf" = {
    source = "${ax-shell}/assets/fonts/tabler-icons/tabler-icons.ttf";
  };

  
  home.file = {
    #Matugen
    ".config/matugen/config.toml" = {
      text = ''
        [config]
reload_apps = true

[config.wallpaper]
command = "swww"
arguments = [
    "img", "-t", "outer",
    "--transition-duration", "1.5",
    "--transition-step", "255",
    "--transition-fps", "60",
    "-f", "Nearest"
]
set = true

[config.custom_colors.red]
color = "#FF0000"
blend = true

[config.custom_colors.green]
color = "#00FF00"
blend = true

[config.custom_colors.yellow]
color = "#FFFF00"
blend = true

[config.custom_colors.blue]
color = "#0000FF"
blend = true

[config.custom_colors.magenta]
color = "#FF00FF"
blend = true

[config.custom_colors.cyan]
color = "#00FFFF"
blend = true

[config.custom_colors.white]
color = "#FFFFFF"
blend = true

[templates.hyprland]
input_path = "~/.config/Ax-Shell/config/matugen/templates/hyprland-colors.conf"
output_path = "~/.config/matugen/config/hypr/colors.conf"

[templates.ax-shell]
input_path = "~/.config/Ax-Shell/config/matugen/templates/ax-shell.css"
output_path = "~/.config/matugen/styles/colors.css"
post_hook = "fabric-cli exec ax-shell 'app.set_css()' &; python3 ~/.config/Ax-Shell/vesktop_preprocessor.py &"


      '';
    };
  };
   
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin  "fabric-bar" ''
#!/usr/bin/env bash

uwsm -- app run-widget ~/.config/Ax-Shell/main.py > /dev/null 2>&1 & disown'')
    matugen
    cava
    #fabric-bar
    #hyprsunset
    wlinhibit
    tesseract
    imagemagick
    nur.repos.HeyImKyu.fabric-cli
    (nur.repos.HeyImKyu.run-widget.override {
      extraPythonPackages = with python3Packages; [
        ijson
        pillow
        psutil
        requests
        setproctitle
        toml
        watchdog
        thefuzz
        numpy
        chardet
      ];
      extraBuildInputs = [
        nur.repos.HeyImKyu.fabric-gray
        networkmanager
        networkmanager.dev
        playerctl
      ];
    })
  ];
  

  wayland.windowManager.hyprland.settings.layerrule = [
    "noanim, fabric"
  ];
}
