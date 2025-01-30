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

        p ~/.cache/wal/btop-colors.theme ~/.config/btop/themes/pywal.theme


      cp ~/.cache/wal/colors-wlogout.css ~/.config/wlogout/colors.css



                        



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

        ## Reload Apps

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
          did=$(ps -eaf | grep nwg-dock-hyprland | grep -v "grep nwg-dock-hyprland" | awk '{print $2}' | xargs)
           kill -9 $did
           #nwg-dock-hyprland &
           'toggle-dock'

           # #Hyprpanel
          did=$(ps -eaf | grep hyprpanel | grep -v "grep hyprpanel" | awk '{print $2}' | xargs)
           kill -9 $did
           #nwg-dock-hyprland &
           'toggle-hyprpanel'

          #cava
          pkill -USR1 cava

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
    (writeShellScriptBin "song-script" ''
      #!/bin/bash

# Create the required directory
mkdir -p ~/.config/hypr/Scripts

# Create and write content to the script file
cat > ~/.config/hypr/Scripts/songdetail.sh << 'EOL'
#!/bin/bash
playerctl metadata --format '{{title}}      {{artist}}'
EOL

# Make the script executable
chmod +x ~/.config/hypr/Scripts/songdetail.sh

echo "Song detail script has been created and configured"
    '')

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
        $background = rgb({background.strip})
        $foreground = rgb({foreground.strip})
        $color0 = rgb({color0.strip})
        $color1 = rgb({color1.strip})
        $color2 = rgb({color2.strip})
        $color3 = rgb({color3.strip})
        $color4 = rgb({color4.strip})
        $color5 = rgb({color5.strip})
        $color6 = rgb({color6.strip})
        $color7 = rgb({color7.strip})
        $color8 = rgb({color8.strip})
        $color9 = rgb({color9.strip})
        $color10 = rgb({color10.strip})
        $color11 = rgb({color11.strip})
        $color12 = rgb({color12.strip})
        $color13 = rgb({color13.strip})
        $color14 = rgb({color14.strip})
        $color15 = rgb({color15.strip})
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

    # #Rofi
    # ".config/wal/templates/colors-rofi.rasi" = {
    #   text = ''

    #       background: {background};
    #     foreground: {foreground};
    #     color0: {color0};
    #     color1: {color1};
    #     color2: {color2};
    #     color3: {color3};
    #     color4: {color4};
    #     color5: {color5};
    #     color6: {color6};
    #     color7: {color7};
    #     color8: {color8};
    #     color9: {color9};
    #     color10: {color10};
    #     color11: {color11};
    #     color12: {color12};
    #     color13: {color13};
    #     color14: {color14};
    #     color15: {color15};

    #   '';
    # };



    #Rofi 2
    ".config/wal/templates/colors-rofi.rasi" = {
      text = ''
* {{
    active-background: {color2}88;
    active-foreground: @foreground;
    normal-background: transparent;
    normal-foreground: @foreground;
    urgent-background: {color1}88;
    urgent-foreground: @foreground;

    alternate-active-background: @background;
    alternate-active-foreground: @foreground;
    alternate-normal-background: transparent;
    alternate-normal-foreground: @foreground;
    alternate-urgent-background: @background;
    alternate-urgent-foreground: @foreground;

    selected-active-background: {color1}AA;
    selected-active-foreground: @foreground;
    selected-normal-background: {color2}AA;
    selected-normal-foreground: @foreground;
    selected-urgent-background: {color3}AA;
    selected-urgent-foreground: @foreground;

    background-color: @background;
    background: {background}88;
    foreground: {foreground};
    border-color: @background;
    spacing: 2;
}}

#window {{
    background-color: @background;
    border: 0;
    padding: 2.5ch;
}}

#mainbox {{
    border: 0;
    padding: 0;
}}

#message {{
    border: 2px 0px 0px;
    border-color: @border-color;
    padding: 1px;
}}

#textbox {{
    text-color: @foreground;
}}

#inputbar {{
    children:   [ prompt,textbox-prompt-colon,entry,case-indicator ];
}}

#textbox-prompt-colon {{
    expand: false;
    str: ">";
    margin: 0px 0.3em 0em 0em;
    text-color: @normal-foreground;
}}

#listview {{
    fixed-height: 0;
    border-color: @border-color;
    spacing: 2px;
    scrollbar: true;
    padding: 2px 0px 0px;
}}

#element {{
    border: 0;
    padding: 1px;
}}

#element-text, element-icon {{
    background-color: @normal-background;
    text-color:       inherit;
}}

#element.normal.normal {{
    background-color: @normal-background;
    text-color: @normal-foreground;
}}

#element.normal.urgent {{
    background-color: @urgent-background;
    text-color: @urgent-foreground;
}}

#element.normal.active {{
    background-color: @active-background;
    text-color: @active-foreground;
}}

#element.selected.normal {{
    background-color: @selected-normal-background;
    text-color: @selected-normal-foreground;
}}

#element.selected.urgent {{
    background-color: @selected-urgent-background;
    text-color: @selected-urgent-foreground;
}}

#element.selected.active {{
    background-color: @selected-active-background;
    text-color: @selected-active-foreground;
}}

#element.alternate.normal {{
    background-color: @alternate-normal-background;
    text-color: @alternate-normal-foreground;
}}

#element.alternate.urgent {{
    background-color: @alternate-urgent-background;
    text-color: @alternate-urgent-foreground;
}}

#element.alternate.active {{
    background-color: @alternate-active-background;
    text-color: @alternate-active-foreground;
}}

#scrollbar {{
    width: 4px;
    handle-width: 8px;
    padding: 0;
    border-radius: 100px;
}}

#sidebar {{
    border-radius: 100px;
}}

#button {{
    text-color: @normal-foreground;
}}

#button.selected {{
    background-color: @selected-normal-background;
    text-color: @selected-normal-foreground;
}}

#inputbar {{
    spacing: 0;
    text-color: @normal-foreground;
}}

#case-indicator {{
    spacing: 0;
    text-color: @normal-foreground;
}}

#entry {{
    spacing: 0;
    text-color: @normal-foreground;
}}

#prompt {{
    spacing: 0;
    text-color: @normal-foreground;
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
