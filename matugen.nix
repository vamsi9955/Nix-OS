{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    matugen
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

      ## Copy matugen colors to waybar
      cp ~/.cache/matugen/colors-waybar.css ~/.config/waybar/colors.css

      # Copy colors to config locations
      cp ~/.cache/matugen/colors-alacritty.toml ~/.config/alacritty/colors.toml
      cp ~/.cache/matugen/colors-kitty.conf ~/.config/kitty/colors.conf
      cp ~/.cache/matugen/colors-gtk3.css ~/.config/gtk-3.0/colors.css
                    
      if [ -f ~/.cache/matugen/colors-cava.conf ]; then
        cp ~/.cache/matugen/colors-cava.conf ~/.config/cava/config
      fi

      cp ~/.cache/matugen/colors-swaync.css ~/.config/swaync/style.css

      cp ~/.cache/matugen/btop-colors.theme ~/.config/btop/themes/matugen.theme

      cp ~/.cache/matugen/colors-wlogout.css ~/.config/wlogout/colors.css

      cp ~/.cache/matugen/templates/colors-hyprland.conf ~/.config/hypr/colors.conf

      # Copy Rofi colors file to the right location
      cp ~/.cache/matugen/colors-rofi.rasi ~/.config/rofi/colors.rasi

      ### Get current wallpaper path from waypaper config
      WALLPAPER="$(
        grep "^wallpaper" ~/.config/waypaper/config.ini \
          | cut -d '=' -f2- \
          | sed 's/^[[:space:]]*//; s/[[:space:]]*$//'
      )"

      echo "Detected wallpaper path: $WALLPAPER"
      WALLPAPER="$(eval echo "$WALLPAPER")"

      # Generate colors using matugen
      # Options for schemes: tonal, vibrant, fruit_salad, rainbow, expressive, content, monochrome, fidelity, neutral, muted
      SCHEME="vibrant"  # Change this to your preferred scheme
      
      # Generate color scheme
      mkdir -p ~/.cache/matugen/
      mkdir -p ~/.config/matugen/templates/
      matugen image "$WALLPAPER" -o ~/.cache/matugen/
      
      # Process templates
      for template in ~/.config/matugen/templates/*; do
        if [ -f "$template" ]; then
          template_name=$(basename "$template")
          matugen apply -i ~/.cache/matugen/colors.json "$template" -o ~/.cache/matugen/"$template_name"
        fi
      done
      
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
# Reload Apps
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

        #Swaync
        swaync-client -rs

        # Hyprpanel
        did=$(ps -eaf | grep hyprpanel | grep -v "grep hyprpanel" | awk '{print $2}' | xargs)
         kill -9 $did
         'toggle-hyprpanel'
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

    # Add wallpaper change script with scheme selection
    (writeShellScriptBin "wallpaper-change" ''
      #!/usr/bin/env bash
      # $1 is the wallpaper path
      # $2 is the optional color scheme (default: vibrant)
      
      WALLPAPER="$1"
      SCHEME="''${2:-vibrant}"
      
      # Available schemes: tonal, vibrant, fruit_salad, rainbow, expressive, content, monochrome, fidelity, neutral, muted
      
      # Generate colors using matugen
      mkdir -p ~/.cache/matugen/
      mkdir -p ~/.config/matugen/templates/
      
      # Generate colors.json with matugen
      # Note: Matugen doesn't support --scheme parameter directly, we'd need to modify templates to achieve different styles
      matugen image "$WALLPAPER" -o ~/.cache/matugen/
      
      # Process templates
      for template in ~/.config/matugen/templates/*; do
        if [ -f "$template" ]; then
          template_name=$(basename "$template")
          matugen apply -i ~/.cache/matugen/colors.json "$template" -o ~/.cache/matugen/"$template_name"
        fi
      done
      
      # Set wallpaper
      swww img "$WALLPAPER"
      
      # Reload theme
      theme-reload
    '')

    # Add variant selection script for matugen
    (writeShellScriptBin "select-variant" ''
      #!/usr/bin/env bash
      
      # Get the current wallpaper
      WALLPAPER="$(grep "^wallpaper" ~/.config/waypaper/config.ini \
        | cut -d '=' -f2- \
        | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')"
      
      WALLPAPER="$(eval echo "$WALLPAPER")"
      
      # List of different customization options for Material You
      # Instead of schemes, we'll use these options for modifying the look
      OPTIONS="Default Dark Light Dark+Black High-Contrast Custom-Saturation"
      
      # Use rofi to select option
      SELECTED_OPTION=$(echo "$OPTIONS" | tr ' ' '\n' | rofi -dmenu -p "Select Material You variant:")
      
      # If an option was selected, apply it
      if [ -n "$SELECTED_OPTION" ]; then
        case "$SELECTED_OPTION" in
          "Default")
            matugen image "$WALLPAPER" -o ~/.cache/matugen/
            ;;
          "Dark")
            matugen image "$WALLPAPER" --dark -o ~/.cache/matugen/
            ;;
          "Light")
            matugen image "$WALLPAPER" --light -o ~/.cache/matugen/
            ;;
          "Dark+Black")
            matugen image "$WALLPAPER" --dark --black -o ~/.cache/matugen/
            ;;
          "High-Contrast")
            matugen image "$WALLPAPER" --contrast-level 3 -o ~/.cache/matugen/
            ;;
          "Custom-Saturation")
            SATURATION=$(rofi -dmenu -p "Enter saturation (0.0-1.0):" -l 0)
            if [[ "$SATURATION" =~ ^[0-9]+(\.[0-9]+)?$ ]] && [ "$(echo "$SATURATION <= 1.0" | bc)" -eq 1 ]; then
              matugen image "$WALLPAPER" --target-saturation "$SATURATION" -o ~/.cache/matugen/
            else
              notify-send "Error" "Invalid saturation value"
              exit 1
            fi
            ;;
        esac
        
        # Process templates after generating colors
        for template in ~/.config/matugen/templates/*; do
          if [ -f "$template" ]; then
            template_name=$(basename "$template")
            matugen apply -i ~/.cache/matugen/colors.json "$template" -o ~/.cache/matugen/"$template_name"
          fi
        done
        
        # Reload theme
        theme-reload
        notify-send "Material You Variant Changed" "Applied $SELECTED_OPTION variant"
      fi
    '')
  ];

  # Create template files for different applications
  home.file = {
    #Hyprland
    ".config/matugen/templates/colors-hyprland.conf" = {
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

    #Waybar
    ".config/matugen/templates/colors-waybar.css" = {
      text = ''
        @define-color primary_accent     {{primary}};
        @define-color secondary_accent   {{tertiary}};
        @define-color tertiary_accent    {{secondary}};
        @define-color background         {{primary_container}};
        @define-color primary_background rgba({{on_primary_container_rgb}},0.81);
        @define-color tertiary_background {{surface}};
        @define-color A-colour  {{secondary_container}};
        @define-color B-Colour  {{tertiary_container}};
        @define-color C-colour  {{error_container}};
        @define-color D-colour  {{on_primary}};
        @define-color E-colour  {{on_secondary}};
        @define-color F-colour  {{on_tertiary}};
        @define-color G-colour  {{on_error}};
        @define-color H-colour  {{on_surface}};
        @define-color I-colour  {{on_surface_variant}};
        @define-color J-colour  {{inverse_surface}};
        @define-color K-colour  {{inverse_primary}};
      '';
    };

    #Kitty
    ".config/matugen/templates/colors-kitty.conf" = {
      text = ''
        foreground         {{on_background}}
        background         {{background}}
        cursor            {{primary}}
        
        active_tab_foreground     {{background}}
        active_tab_background     {{on_background}}
        inactive_tab_foreground   {{on_background}}
        inactive_tab_background   {{background}}
        
        active_border_color   {{on_background}}
        inactive_border_color {{background}}
        bell_border_color     {{error}}
        
        color0       {{surface}}
        color8       {{surface_variant}}
        color1       {{error}}
        color9       {{error_container}}
        color2       {{primary}}
        color10      {{primary_container}}
        color3       {{secondary}}
        color11      {{secondary_container}}
        color4       {{tertiary}}
        color12      {{tertiary_container}}
        color5       {{inverse_primary}}
        color13      {{inverse_surface}}
        color6       {{outline}}
        color14      {{outline_variant}}
        color7       {{on_surface}}
        color15      {{on_surface_variant}}
      '';
    };

    #Alacritty
    ".config/matugen/templates/colors-alacritty.toml" = {
      text = ''
        [colors.primary]
        background = "{{background}}"
        foreground = "{{on_background}}"

        [colors.normal]
        black = "{{surface}}"
        red = "{{error}}"
        green = "{{primary}}"
        yellow = "{{secondary}}"
        blue = "{{tertiary}}"
        magenta = "{{inverse_primary}}"
        cyan = "{{outline}}"
        white = "{{on_surface}}"

        [colors.bright]
        black = "{{surface_variant}}"
        red = "{{error_container}}"
        green = "{{primary_container}}"
        yellow = "{{secondary_container}}"
        blue = "{{tertiary_container}}"
        magenta = "{{inverse_surface}}"
        cyan = "{{outline_variant}}"
        white = "{{on_surface_variant}}"
      '';
    };

    ".config/matugen/templates/colors-cava.conf" = {
      text = ''
        [color]
        gradient = 1
        gradient_count = 8
        gradient_color_1 = '{{primary_hex}}'
        gradient_color_2 = '{{primary_container_hex}}'
        gradient_color_3 = '{{secondary_hex}}'
        gradient_color_4 = '{{secondary_container_hex}}'
        gradient_color_5 = '{{tertiary_hex}}'
        gradient_color_6 = '{{tertiary_container_hex}}'
        gradient_color_7 = '{{error_hex}}'
        gradient_color_8 = '{{error_container_hex}}'
      '';
    };

    #Rofi
    ".config/matugen/templates/colors-rofi.rasi" = {
      text = ''
        /* Matugen color variables for Rofi */
        * {
            background: rgba({{background_rgb}}, 0.8);
            foreground: {{on_background}};
            color0: {{surface}};
            color1: {{error}};
            color2: {{primary}};
            color3: {{secondary}};
            color4: {{tertiary}};
            color5: {{inverse_primary}};
            color6: {{outline}};
            color7: {{on_surface}};
            color8: {{surface_variant}};
            color9: {{error_container}};
            color10: {{primary_container}};
            color11: {{secondary_container}};
            color12: {{tertiary_container}};
            color13: {{inverse_surface}};
            color14: {{outline_variant}};
            color15: {{on_surface_variant}};
        }
      '';
    };

    #Btop
    ".config/matugen/templates/btop-colors.theme" = {
      text = ''
        theme[main_bg]="{{background}}"
        theme[main_fg]="{{on_background}}"
        theme[title]="{{tertiary}}"
        theme[hi_fg]="{{outline}}"
        theme[selected_bg]="{{error}}"
        theme[selected_fg]="{{background}}"
        theme[inactive_fg]="{{surface_variant}}"
        theme[graph_text]="{{on_surface}}"
        theme[meter_bg]="{{surface}}"
        theme[proc_misc]="{{primary}}"
        theme[cpu_box]="{{tertiary}}"
        theme[mem_box]="{{inverse_primary}}"
        theme[net_box]="{{secondary}}"
        theme[proc_box]="{{outline}}"
        theme[div_line]="{{surface_variant}}"
        theme[temp_start]="{{primary}}"
        theme[temp_mid]="{{secondary}}"
        theme[temp_end]="{{error}}"
        theme[cpu_start]="{{primary}}"
        theme[cpu_mid]="{{secondary}}"
        theme[cpu_end]="{{error}}"
        theme[free_start]="{{primary}}"
        theme[free_mid]="{{secondary}}"
        theme[free_end]="{{error}}"
        theme[cached_start]="{{outline}}"
        theme[cached_mid]="{{outline}}"
        theme[cached_end]="{{outline}}"
        theme[available_start]="{{primary}}"
        theme[available_mid]="{{secondary}}"
        theme[available_end]="{{error}}"
        theme[used_start]="{{secondary}}"
        theme[used_mid]="{{secondary}}"
        theme[used_end]="{{error}}"
        theme[download_start]="{{primary}}"
        theme[download_mid]="{{secondary}}"
        theme[download_end]="{{error}}"
        theme[upload_start]="{{primary}}"
        theme[upload_mid]="{{secondary}}"
        theme[upload_end]="{{error}}"
      '';
    };

    #Wlogout
    ".config/matugen/templates/colors-wlogout.css" = {
      text = ''
        @define-color bar-bg rgba(0, 0, 0, 0);
        @define-color main-bg {{background}};
        @define-color main-fg {{on_background}};
        @define-color wb-act-bg {{surface_variant}};
        @define-color wb-act-fg {{background}};
        @define-color wb-hvr-bg {{inverse_primary}};
        @define-color wb-hvr-fg {{background}};
      '';
    };

    #Swaync
    ".config/matugen/templates/colors-swaync.css" = {
      text = ''
        @background: {{surface}};
        @foreground: {{on_surface}};
        @primary: {{primary}};
        @secondary: {{secondary}};
        @accent: {{tertiary}};
        @border: {{outline}};
        @highlight: {{primary_container}};
      '';
    };
  };

  # Ensure cache directories exist
  home.activation.createMatugenCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p $HOME/.cache/matugen
    $DRY_RUN_CMD mkdir -p $HOME/.cache/matugen/templates
    $DRY_RUN_CMD mkdir -p $HOME/.config/matugen/templates
    $DRY_RUN_CMD mkdir -p $HOME/.cache/wallpapers/generated
  '';

  # Install pywalfox for Firefox theming
  home.activation.installPywalfox = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.pywalfox-native}/bin/pywalfox install
  '';
}