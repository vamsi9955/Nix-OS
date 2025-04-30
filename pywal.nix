# { config,lib, pkgs, ... }:

# {
#   home.packages = with pkgs; [
#     pywal
#     pywalfox-native
#   ];

#   # Create necessary directories and templates
#   home.file.".config/wal/templates" = {
#     text = "";
#     directory = true;
#   };

#   # Add activation script to ensure cache directory exists
#   home.activation.createPywalCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
#     $DRY_RUN_CMD mkdir -p $HOME/.cache/wal
#   '';

#   # Optional: Add pywalfox for Firefox theming
#   # home.activation.installPywalfox = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
#   #   $DRY_RUN_CMD ${pkgs.pywalfox-native}/bin/pywalfox install
#   # '';
# }

{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    pywal
    pywalfox-native

    #Theme Reload
    (writeShellScriptBin "theme-reload" ''
                    #!/usr/bin/env bash


            #Issue with waypaper at first Nix-Os rebuild is fixed below 
                      CONFIG="$HOME/.config/waypaper/config.ini"

                      # Ensure config.ini exists and has a wallpaper line
                      if [ ! -f "$CONFIG" ] || ! grep -q '^wallpaper' "$CONFIG"; then
                        mkdir -p "$(dirname "$CONFIG")"
                        waypaper --backend swww --wallpaper /etc/nixos/wallpaper.jpg
                      fi




    ## Copy pywal colors to waybar
      cp ~/.cache/wal/colors-waybar.css ~/.config/waybar/colors.css


      # Copy colors to config locations

      cp ~/.cache/wal/colors-alacritty.toml ~/.config/alacritty/colors.toml
      cp ~/.cache/wal/colors-kitty.conf ~/.config/kitty/colors.conf
      cp ~/.cache/wal/colors-gtk3.css ~/.config/gtk-3.0/colors.css
                    
      if [ -f ~/.cache/wal/colors-cava.conf ]; then
      cp ~/.cache/wal/colors-cava.conf ~/.config/cava/config
      fi

      cp ~/.cache/wal/colors-swaync.css ~/.config/swaync/style.css

      cp ~/.cache/wal/btop-colors.theme ~/.config/btop/themes/pywal.theme


      cp ~/.cache/wal/colors-wlogout.css ~/.config/wlogout/colors.css

      cp ~/.cache/wal/templates/colors-hyprland.conf ~/.config/wal/templates/colors-hyprland.conf


 # Copy Rofi colors file to the right location
      cp ~/.cache/wal/colors-rofi.rasi ~/.config/rofi/colors.rasi

      

      # Ensure Rofi colors are properly copied
      cp ~/.cache/wal/colors-rofi.rasi ~/.config/rofi/colors.rasi


                        



  ## Generate pywal colors from current wallpaper ##If path is known
      #wal -i "$(cat ~/.config/waypaper/wallpaper.path)" 

     ### Get current wallpaper path from waypaper config

                    WALLPAPER="$(
                  grep "^wallpaper" ~/.config/waypaper/config.ini \
                    | cut -d '=' -f2- \
                    | sed 's/^[[:space:]]*//; s/[[:space:]]*$//'
                )"

                   echo "Detected wallpaper path: $WALLPAPER"
                   WALLPAPER="$(eval echo "$WALLPAPER")"

                    # Generate colors using pywal
                    wal -i "$WALLPAPER" --saturate 0.8
                    
                    ## Apply GTK theme changes
                    gsettings set org.gnome.desktop.interface gtk-theme "Catppuccin-GTK-Purple-Dark"
                    

                  ##Waypaper command only need once but runs always when theme-switch executes "it's OK"
                   CONFIG="$HOME/.config/waypaper/config.ini"

                    # If we already have a post_command line, change it in place;
                    # otherwise, append it to the file.
                    if grep -q '^post_command' "$CONFIG"; then
                      sed -i 's/^post_command.*/post_command = "theme-reload"/' "$CONFIG"
                    else
                      echo 'post_command = "theme-reload"' >> "$CONFIG"
                    fi


                   # Generate colors using wpgtk
                    wpg -s "$WALLPAPER"

                  wal -i "$WALLPAPER" --saturate 0.8



# -----------------------------------------------------
# Create blurred and square wallpapers
# -----------------------------------------------------

# Define variables
WALLPAPER_FILENAME=$(basename "$WALLPAPER")
WALLPAPER_NAME=$(echo "$WALLPAPER_FILENAME" | sed 's/\.[^.]*$//')

GENERATED_VERSIONS="$HOME/.cache/wallpapers/generated"
BLURRED_WALLPAPER="$GENERATED_VERSIONS/blurred.png"
SQUARE_WALLPAPER="$GENERATED_VERSIONS/square-$WALLPAPER_NAME.png"
BLUR="0x8"
EFFECT="none"
FORCE_GENERATE="0"
USE_CACHE="1"
TMP_WALLPAPER="$HOME/.cache/wallpapers/tmp-$WALLPAPER_NAME.png"
ROFI_BG_FILE="$HOME/.config/rofi/current_wallpaper_bg.rasi"
RASI_FILE="$HOME/.cache/wallpapers/current_wallpaper.rasi"

# Create cache directory
mkdir -p "$GENERATED_VERSIONS"

# Create temporary resized wallpaper
cp "$WALLPAPER" "$TMP_WALLPAPER"

# Create blurred wallpaper
if [ -f "$GENERATED_VERSIONS/blur-$BLUR-$EFFECT-$WALLPAPER_NAME.png" ] && [ "$FORCE_GENERATE" = "0" ] && [ "$USE_CACHE" = "1" ]; then
    echo ":: Using cached blurred wallpaper"
    cp "$GENERATED_VERSIONS/blur-$BLUR-$EFFECT-$WALLPAPER_NAME.png" "$BLURRED_WALLPAPER"
else
    echo ":: Generating blurred wallpaper"
    magick "$TMP_WALLPAPER" -resize 75% "$BLURRED_WALLPAPER"
    if [ "$BLUR" != "0x0" ]; then
        magick "$BLURRED_WALLPAPER" -blur "$BLUR" "$BLURRED_WALLPAPER"
    fi
    cp "$BLURRED_WALLPAPER" "$GENERATED_VERSIONS/blur-$BLUR-$EFFECT-$WALLPAPER_NAME.png"
fi

# Create Rofi background file
echo "* { background-image: url(\"$BLURRED_WALLPAPER\", height); }" > "$ROFI_BG_FILE"

# Create Rasi file for wallpaper
echo "* { current-image: url(\"$BLURRED_WALLPAPER\", height); }" > "$RASI_FILE"

# Create square wallpaper
echo ":: Generating square wallpaper"
magick "$TMP_WALLPAPER" -gravity center -extent 1:1 "$SQUARE_WALLPAPER"





# -----------------------------------------------------
    ## Reload Apps
# -----------------------------------------------------

# Update Pywalfox if available
if type pywalfox >/dev/null 2>&1; then
    pywalfox update
fi
        #Hyprlock
        "wallpaperHyprlock"
        "song-script"
         
         #Waybar
          pid=$(ps -eaf | grep waybar | grep -v "grep waybar" | awk '{print $2}' | xargs)
           kill -9 $pid
           waybar &

         #Rofi
          if pgrep -x "rofi" > /dev/null; then
          # Rofi is running, kill it
          pkill -x rofi
          exit 0
           fi
            #rofi -show drun  #reopens rofi

          #Swaync
          #${pkgs.swaynotificationcenter}/bin/swaync-client -rs
          swaync-client -rs

          # #nwg-dock
          # did=$(ps -eaf | grep nwg-dock-hyprland | grep -v "grep nwg-dock-hyprland" | awk '{print $2}' | xargs)
          #  kill -9 $did
          #  #nwg-dock-hyprland &
          #  'toggle-dock'

           # #Hyprpanel
          did=$(ps -eaf | grep hyprpanel | grep -v "grep hyprpanel" | awk '{print $2}' | xargs)
           kill -9 $did
           #nwg-dock-hyprland &
           'toggle-hyprpanel'

          #cava
          #pkill -USR1 cava

    '')


(writeShellScriptBin "wallpaperHyprlock" ''
  #!/bin/bash

  # Define paths
  WAYPAPER_CONFIG="$HOME/.config/waypaper/config.ini"
  HYPRLOCK_PATH="$HOME/.config/hypr"
  HYPRLOCK_WALLPAPER="$HYPRLOCK_PATH/hyprlock.png"

  # Create hypr directory if it doesn't exist
  mkdir -p "$HYPRLOCK_PATH"

  # Check if ImageMagick is installed
  if ! command -v convert >/dev/null 2>&1; then
      echo "Error: ImageMagick is not installed. Please install it first."
      exit 1
  fi

  # Get current wallpaper path from waypaper config.ini
  if [ -f "$WAYPAPER_CONFIG" ]; then
      # Get current wallpaper path from waypaper config
      CURRENT_WALLPAPER="$(grep "^wallpaper" "$WAYPAPER_CONFIG" \
          | cut -d '=' -f2- \
          | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')"

      echo "Detected wallpaper path: $CURRENT_WALLPAPER"
      CURRENT_WALLPAPER="$(eval echo "$CURRENT_WALLPAPER")"

      # Check if we got a wallpaper path
      if [ -n "$CURRENT_WALLPAPER" ] && [ -f "$CURRENT_WALLPAPER" ]; then
          # Get file extension
          FILE_EXT="''${CURRENT_WALLPAPER##*.}"
          
          if [ "''${FILE_EXT,,}" = "png" ]; then
              # If it's already PNG, just copy
              cp "$CURRENT_WALLPAPER" "$HYPRLOCK_WALLPAPER"
          else
              # Convert to PNG using ImageMagick
              magick "$CURRENT_WALLPAPER" "$HYPRLOCK_WALLPAPER"
          fi
          
          echo "Successfully copied/converted wallpaper to $HYPRLOCK_WALLPAPER"
      else
          echo "Error: Current wallpaper not found"
          exit 1
      fi
  else
      echo "Error: Waypaper config.ini not found"
      exit 1
  fi
'')

# Add wallpaper change script
 
 
    # Add wallpaper change script
    (writeShellScriptBin "wallpaper-change" ''
      #!/usr/bin/env bash
      wal -i "$1" --saturate 0.8
      swww img "$1"
      theme-reload
    '')

    #   (writeShellScriptBin "theme-reload" ''
    #   #!/usr/bin/env bash
    #   # Reload waybar
    #   pkill -SIGUSR2 waybar || (pkill waybar && waybar &)

    #   # Copy colors to waybar directory
    #   cp ~/.cache/wal/colors-waybar.css ~/.config/waybar/colors.css

    #   # Reload rofi
    #   pkill rofi

    #   # Notify user
    #   notify-send "Theme Reloaded" "Color scheme has been updated"
    # '')
  ];

  # Create template files for different applications
  home.file = {

    #Hyprland
    ".config/wal/templates/colors-hyprland.conf" = {
      text = ''
        background={{background}}
        foreground={{foreground}}
        color0={{color0}}
        color1={{color1}}
        color2={{color2}}
        color3={{color3}}
        color4={{color4}}
        color5={{color5}}
        color6={{color6}}
        color7={{color7}}
        color8={{color8}}
        color9={{color9}}
        color10={{color10}}
        color11={{color11}}
        color12={{color12}}
        color13={{color13}}
        color14={{color14}}
        color15={{color15}}

      '';
    };



 




    # ".config/wal/templates/colors-waybar.css" = {
    #   text = ''
    #     @define-color background     {background};
    #     @define-color foreground     {foreground};
    #     @define-color cursor         {cursor};

    #     @define-color color0         {color0};
    #     @define-color color1         {color1};
    #     @define-color color2         {color2};
    #     @define-color color3         {color3};
    #     @define-color color4         {color4};
    #     @define-color color5         {color5};
    #     @define-color color6         {color6};
    #     @define-color color7         {color7};
    #     @define-color color8         {color8};
    #     @define-color color9         {color9};
    #     @define-color color10        {color10};
    #     @define-color color11        {color11};
    #     @define-color color12        {color12};
    #     @define-color color13        {color13};
    #     @define-color color14        {color14};
    #     @define-color color15        {color15};
    #   '';
    # };

    #Waybar
    ".config/wal/templates/colors-waybar.css" = {
      text = ''
        @define-color primary_accent     {color2};
        @define-color secondary_accent   {color4};
        @define-color tertiary_accent    {color7};
        @define-color background         {color5};
        @define-color primary_background rgba({color1.rgb},0.81);
        @define-color tertiary_background {color0};
        @define-color A-colour  {color3};
        @define-color B-Colour  {color6};
        @define-color C-colour  {color7};
        @define-color D-colour  {color8};
        @define-color E-colour  {color9};
        @define-color F-colour  {color10};
        @define-color G-colour  {color11};
        @define-color H-colour  {color12};
        @define-color I-colour  {color13};
        @define-color J-colour  {color14};
        @define-color K-colour  {color15};

      '';
    };


      #Kitty
      ".config/wal/templates/colors-kitty.conf" = {
    text = ''
      foreground         {foreground}
      background         {background}
      cursor            {cursor}
      
      active_tab_foreground     {background}
      active_tab_background     {foreground}
      inactive_tab_foreground   {foreground}
      inactive_tab_background   {background}
      
      active_border_color   {foreground}
      inactive_border_color {background}
      bell_border_color     {color1}
      
      color0       {color0}
      color8       {color8}
      color1       {color1}
      color9       {color9}
      color2       {color2}
      color10      {color10}
      color3       {color3}
      color11      {color11}
      color4       {color4}
      color12      {color12}
      color5       {color5}
      color13      {color13}
      color6       {color6}
      color14      {color14}
      color7       {color7}
      color15      {color15}
    '';
  };





    #Alacritty
    ".config/wal/templates/colors-alacritty.toml" = {
      text = ''
        [colors.primary]
        background = "{background}"
        foreground = "{foreground}"

        [colors.normal]
        black = "{color0}"
        red = "{color1}"
        green = "{color2}"
        yellow = "{color3}"
        blue = "{color4}"
        magenta = "{color5}"
        cyan = "{color6}"
        white = "{color7}"

        [colors.bright]
        black = "{color8}"
        red = "{color9}"
        green = "{color10}"
        yellow = "{color11}"
        blue = "{color12}"
        magenta = "{color13}"
        cyan = "{color14}"
        white = "{color15}"
      '';
    };

    ".config/wal/templates/colors-cava.conf" = {
      text = ''
    [color]
    gradient = 1
    gradient_count = 8
    gradient_color_1 = '#{color1}'
    gradient_color_2 = '#{color2}'
    gradient_color_3 = '#{color3}'
    gradient_color_4 = '#{color4}'
    gradient_color_5 = '#{color5}'
    gradient_color_6 = '#{color6}'
    gradient_color_7 = '#{color7}'
    gradient_color_8 = '#{color8}'
  '';
    };

    #Rofi
    # Rofi color variables template
    ".config/wal/templates/colors-rofi.rasi" = {
      text = ''
/* Pywal color variables for Rofi */
* {{
    background: rgba({background.rgb}, 0.8);
    foreground: {foreground};
    color0: {color0};
    color1: {color1};
    color2: {color2};
    color3: {color3};
    color4: {color4};
    color5: {color5};
    color6: {color6};
    color7: {color7};
    color8: {color8};
    color9: {color9};
    color10: {color10};
    color11: {color11};
    color12: {color12};
    color13: {color13};
    color14: {color14};
    color15: {color15};
}}
      '';
    };







#Btop
".config/wal/templates/btop-colors.theme" = {
  text = ''
    theme[main_bg]="#{background}"
    theme[main_fg]="#{foreground}"
    theme[title]="#{color4}"
    theme[hi_fg]="#{color6}"
    theme[selected_bg]="#{color1}"
    theme[selected_fg]="#{background}"
    theme[inactive_fg]="#{color8}"
    theme[graph_text]="#{color7}"
    theme[meter_bg]="#{color0}"
    theme[proc_misc]="#{color2}"
    theme[cpu_box]="#{color4}"
    theme[mem_box]="#{color5}"
    theme[net_box]="#{color3}"
    theme[proc_box]="#{color6}"
    theme[div_line]="#{color8}"
    theme[temp_start]="#{color2}"
    theme[temp_mid]="#{color3}"
    theme[temp_end]="#{color1}"
    theme[cpu_start]="#{color2}"
    theme[cpu_mid]="#{color3}"
    theme[cpu_end]="#{color1}"
    theme[free_start]="#{color2}"
    theme[free_mid]="#{color3}"
    theme[free_end]="#{color1}"
    theme[cached_start]="#{color6}"
    theme[cached_mid]="#{color6}"
    theme[cached_end]="#{color6}"
    theme[available_start]="#{color2}"
    theme[available_mid]="#{color3}"
    theme[available_end]="#{color1}"
    theme[used_start]="#{color3}"
    theme[used_mid]="#{color3}"
    theme[used_end]="#{color1}"
    theme[download_start]="#{color2}"
    theme[download_mid]="#{color3}"
    theme[download_end]="#{color1}"
    theme[upload_start]="#{color2}"
    theme[upload_mid]="#{color3}"
    theme[upload_end]="#{color1}"
  '';
};

#Wlogout
".config/wal/templates/colors-wlogout.css" = {
  text = ''
    @define-color bar-bg rgba(0, 0, 0, 0);
    @define-color main-bg {background};
    @define-color main-fg {foreground};
    @define-color wb-act-bg {color8};
    @define-color wb-act-fg {background};
    @define-color wb-hvr-bg {color5};
    @define-color wb-hvr-fg {background};
  '';
};




# #Swaync
".config/wal/templates/colors-swaync.css" = {
   text = ''
    @background: {color0};
    @foreground: {color7};
    @primary: {color1};
    @secondary: {color2};
    @accent: {color4};
    @border: {color5};
    @highlight: {color6};
   '';
};




  };

  # Ensure cache directory exists
  home.activation.createPywalCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p $HOME/.cache/wal
  '';





  home.activation.installPywalfox = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.pywalfox-native}/bin/pywalfox install
  '';
}
