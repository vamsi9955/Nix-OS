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

# ##Rofi wallpaper
      # (writeShellScriptBin "wallpaperRofi" ''
      #   #!/bin/bash

      #   # Define paths
      #   WAYPAPER_CONFIG="$HOME/.config/waypaper/config.ini"
      #   # ROFI_PATH="$HOME/.config/rofi/wall"
      #   # ROFI_WALLPAPER="$ROFI_PATH/wall.png"


      #   # Create hypr directory if it doesn't exist
      #   mkdir -p "$ROFI_PATH"

      #   # Check if ImageMagick is installed
      #   if ! command -v convert >/dev/null 2>&1; then
      #       echo "Error: ImageMagick is not installed. Please install it first."
      #       exit 1
      #   fi

      #   # Get current wallpaper path from waypaper config.ini
      #   if [ -f "$WAYPAPER_CONFIG" ]; then
      #       # Get current wallpaper path from waypaper config
      #       CURRENT_WALLPAPER="$(grep "^wallpaper" "$WAYPAPER_CONFIG" \
      #           | cut -d '=' -f2- \
      #           | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')"

      #       echo "Detected wallpaper path: $CURRENT_WALLPAPER"
      #       CURRENT_WALLPAPER="$(eval echo "$CURRENT_WALLPAPER")"

      #       # Check if we got a wallpaper path
      #       if [ -n "$CURRENT_WALLPAPER" ] && [ -f "$CURRENT_WALLPAPER" ]; then
      #           # Get file extension
      #           FILE_EXT="''${CURRENT_WALLPAPER##*.}"
                
      #           if [ "''${FILE_EXT,,}" = "png" ]; then
      #               # If it's already PNG, just copy
      #               cp "$CURRENT_WALLPAPER" "$ROFI_WALLPAPER"
      #           else
      #               # Convert to PNG using ImageMagick
      #               magick "$CURRENT_WALLPAPER" "$ROFI_WALLPAPER"
      #           fi
                
      #           echo "Successfully copied/converted wallpaper to $ROFI_WALLPAPER"
      #       else
      #           echo "Error: Current wallpaper not found"
      #           exit 1
      #       fi
      #   else
      #       echo "Error: Waypaper config.ini not found"
      #       exit 1
      #   fi
      # '')

     


(writeShellScriptBin "wallpaperRofi" ''
#!/bin/bash
# Define paths
WAYPAPER_CONFIG="$HOME/.config/waypaper/config.ini"
CACHE_DIR="''${XDG_CACHE_HOME:-$HOME/.cache}/rofi"
ROFI_WALLPAPER="$CACHE_DIR/wall.png"

# Create necessary directory
mkdir -p "$CACHE_DIR"

# Check if ImageMagick is installed (using convert or magick)
if command -v magick >/dev/null 2>&1; then
  MAGICK_CMD="magick"
elif command -v convert >/dev/null 2>&1; then
  MAGICK_CMD="convert"
else
  echo "Error: ImageMagick is not installed. Please install it first."
  exit 1
fi
#____________________________________________
## For Video wallpapers

# # # Check if file command is available
# # if ! command -v file >/dev/null 2>&1; then
# #   echo "Error: 'file' command is not installed. Please install it first."
# #   exit 1
# # fi

# # # Function to extract thumbnail from video
# # extract_thumbnail() {
# #   local video="$1" out="$2"
# #   if command -v ffmpeg >/dev/null 2>&1; then
# #     ffmpeg -i "$video" -vframes 1 "$out" -y 2>/dev/null
# #   else
# #     echo "Error: ffmpeg required for video thumbnails."
# #     exit 1
# #   fi
# # }

# # Function to create preview images
# create_previews() {
#   local hash="$1" wall="$2" tmp
#   # Check if it's a video
#   if file --mime-type -b "$wall" | grep -q '^video/'; then
#     tmp="/tmp/''${hash}.png"
#     extract_thumbnail "$wall" "$tmp"
#     wall="$tmp"
#   fi
#_________________________________________

# Function to create preview images with fixed names
create_previews() {
  local wall="$1"
  
  # Generate thumbnails with fixed filenames
  $MAGICK_CMD "$wall"[0] -strip -resize 1000x -gravity center -extent 1000x1000 -quality 90 "$CACHE_DIR/wall.thmb"
  $MAGICK_CMD "$wall"[0] -strip -thumbnail 500x500^ -gravity center -extent 500x500 "$CACHE_DIR/wall.sqre.png" && mv "$CACHE_DIR/wall.sqre.png" "$CACHE_DIR/wall.sqre"
  $MAGICK_CMD "$wall"[0] -strip -scale 10% -blur 0x3 -resize 100% "$CACHE_DIR/wall.blur"
  $MAGICK_CMD "$CACHE_DIR/wall.sqre" \
    \( -size 500x500 xc:white -fill "rgba(0,0,0,0.7)" -draw "polygon 400,500 500,500 500,0 450,0" \
    -fill black -draw "polygon 500,500 500,0 450,500" \) \
    -alpha Off -compose CopyOpacity -composite "$CACHE_DIR/wall.quad.png" && mv "$CACHE_DIR/wall.quad.png" "$CACHE_DIR/wall.quad"
}

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
    # Copy to rofi cache
    cp "$CURRENT_WALLPAPER" "$ROFI_WALLPAPER"
    
    # Create preview images with fixed names
    create_previews "$CURRENT_WALLPAPER"
    
    echo "Successfully processed wallpaper images:"
    echo "- Main copy: $ROFI_WALLPAPER"
    echo "- Thumbnail: $CACHE_DIR/wall.thmb"
    echo "- Square: $CACHE_DIR/wall.sqre"
    echo "- Blur: $CACHE_DIR/wall.blur"
    echo "- Quad: $CACHE_DIR/wall.quad"
  else
    echo "Error: Current wallpaper not found"
    exit 1
  fi
else
  echo "Error: Waypaper config.ini not found"
  exit 1
fi
'')


      ##__________________________________________________________

      (pkgs.writeShellScriptBin "rofiselect" ''
#!/usr/bin/env bash
#Copying previews
"copyRofiPreviews_Styles"

# Set variables
rofiStyleDir="$HOME/.config/rofi/styles"
rofiAssetDir="$HOME/.config/rofi/assets"

# Debug: Check if directories exist
if [ ! -d "''${rofiStyleDir}" ]; then
  notify-send -a "Rofi Style Error" -u critical "Style directory does not exist: ''${rofiStyleDir}"
  exit 1
fi

if [ ! -d "''${rofiAssetDir}" ]; then
  notify-send -a "Rofi Style Error" -u critical "Asset directory does not exist: ''${rofiAssetDir}"
  exit 1
fi

# Debug: List available styles and assets
styleCount=$(find "''${rofiStyleDir}" -type f -name "*.rasi" | wc -l)
assetCount=$(find "''${rofiAssetDir}" -type f -name "*.png" | wc -l)
notify-send -a "Rofi Style Info" -t 2000 "Found ''${styleCount} styles and ''${assetCount} assets"

# Set rofi scaling
font_scale=''${ROFI_SELECT_SCALE}
[[ "''${font_scale}" =~ ^[0-9]+$ ]] || font_scale=''${ROFI_SCALE:-10}

# Set font name
font_name=''${ROFI_SELECT_FONT:-''${ROFI_FONT}}
font_name=''${font_name:-"JetBrainsMono Nerd Font"}

# Set rofi font override
font_override="* {font: \"''${font_name:-"JetBrainsMono Nerd Font"} ''${font_scale}\";}"

# Set border values
hypr_border=''${hypr_border:-10}  # Default value if not set
elem_border=$((hypr_border * 5))
icon_border=$((elem_border - 5))

# Scale for monitor
mon_data=$(hyprctl -j monitors 2>/dev/null)
if [ $? -ne 0 ]; then
  # Fallback if hyprctl fails
  mon_x_res=1920
  mon_scale=100
else
  mon_x_res=$(jq '.[] | select(.focused==true) | if (.transform % 2 == 0) then .width else .height end' <<<"''${mon_data}")
  mon_scale=$(jq '.[] | select(.focused==true) | .scale' <<<"''${mon_data}" | sed "s/\.//")
  if [ -z "''${mon_scale}" ] || [ "''${mon_scale}" -eq 0 ]; then
    mon_scale=100
  fi
  if [ -z "''${mon_x_res}" ] || [ "''${mon_x_res}" -eq 0 ]; then
    mon_x_res=1920
  fi
fi
mon_x_res=$((mon_x_res * 100 / mon_scale))

# Generate config
elm_width=$(((20 + 12 + 16) * font_scale))
max_avail=$((mon_x_res - (4 * font_scale)))
col_count=$((max_avail / elm_width))
[[ "''${col_count}" -gt 5 ]] && col_count=5

r_override="window{width:100%;}
listview{columns:''${col_count};}
element{orientation:vertical;border-radius:''${elem_border}px;}
element-icon{border-radius:''${icon_border}px;size:20em;}
element-text{enabled:true;}"  # Changed to true to show names

# Create temporary file to see what we're finding
temp_file=$(mktemp)
echo "Searching for style files in: ''${rofiStyleDir}" > "''${temp_file}"

# Modified approach to find all .rasi files instead of relying on grep pattern
find "''${rofiStyleDir}" -type f -name "*.rasi" | while read -r file; do
  baseName=$(basename "''${file}" .rasi)
  assetFile="''${rofiAssetDir}/''${baseName}.png"
  
  # Check if asset file exists
  if [ -f "''${assetFile}" ]; then
    echo "Found style: ''${baseName} with matching asset" >> "''${temp_file}"
    echo -en "''${baseName}\x00icon\x1f''${assetFile}\n"
  else
    echo "Style ''${baseName} has no matching asset at ''${assetFile}" >> "''${temp_file}"
    # Still show the style even without an asset
    echo -en "''${baseName}\x00icon\x1f\n"
  fi
done | sort -n > /tmp/rofi_items.txt

# Debug: Store results for inspection
cat /tmp/rofi_items.txt | wc -l > /tmp/rofi_item_count.txt

# Launch rofi menu
RofiSel=$(cat /tmp/rofi_items.txt | rofi -dmenu \
  -theme-str "''${font_override}" \
  -theme-str "''${r_override}" \
  -theme "''${ROFI_SELECT_STYLE:-selector}" \
  -select "''${rofiStyle}"
)

# Apply rofi style
if [ -n "''${RofiSel}" ]; then
  # Instead of using set_conf, write to a file that can be used to track the style
  echo "''${RofiSel}" > "$HOME/.config/rofi/current_style"
  assetPath="''${rofiAssetDir}/''${RofiSel}.png"
  
  if [ -f "''${assetPath}" ]; then
    notify-send -a "Rofi Style" -r 2 -t 2200 -i "''${assetPath}" " Style ''${RofiSel} applied..."
  else
    notify-send -a "Rofi Style" -r 2 -t 2200 " Style ''${RofiSel} applied (no image found)..."
  fi
fi

if [ -n "''${ROFI_LAUNCH_STYLE}" ]; then
  notify-send -a "Rofi Style" -r 3 -u critical "Style: ''${ROFI_LAUNCH_STYLE} is explicitly set in your environment."
fi

# Debug: Show log
notify-send -a "Rofi Debug" -t 3000 "Check log at ''${temp_file}"

'')

      #___________________________________________
      (writeShellScriptBin "rofilaunch" ''
        #!/usr/bin/env bash

        # Set style directory paths
        rofiStyleDir="$HOME/.config/rofi/styles"
        rofiAssetDir="$HOME/.config/rofi/assets"

        # Read the saved style from the current_style file if it exists
        if [ -f "$HOME/.config/rofi/current_style" ]; then
            rofiStyle=$(cat "$HOME/.config/rofi/current_style")
        else
            rofiStyle="style_1"  # Default style if no selection found
        fi

        # Ensure the style file exists, otherwise fall back to style_1
        if [ ! -f "$rofiStyleDir/$rofiStyle.rasi" ]; then
            echo "Selected style '$rofiStyle' not found, falling back to style_1"
            rofiStyle="style_1"
        fi

        # Get style override from environment if set
        rofi_config="''${ROFI_LAUNCH_STYLE:-$rofiStyle}"

        # Set font scaling
        font_scale="''${ROFI_LAUNCH_SCALE}"
        [[ "''${font_scale}" =~ ^[0-9]+$ ]] || font_scale=''${ROFI_SCALE:-10}

        # Base args for rofi
        rofi_args=(
            -show-icons
        )

        # Set mode based on argument
        case "''${1}" in
        d | --drun)
            r_mode="drun"
            rofi_config="''${ROFI_LAUNCH_DRUN_STYLE:-$rofi_config}"
            rofi_args+=("--run-command" "sh -c '{cmd}'")
            ;;
        w | --window)
            r_mode="window"
            rofi_config="''${ROFI_LAUNCH_WINDOW_STYLE:-$rofi_config}"
            ;;
        f | --filebrowser)
            r_mode="filebrowser"
            rofi_config="''${ROFI_LAUNCH_FILEBROWSER_STYLE:-$rofi_config}"
            ;;
        r | --run)
            r_mode="run"
            rofi_config="''${ROFI_LAUNCH_RUN_STYLE:-$rofi_config}"
            rofi_args+=("--run-command" "sh -c '{cmd}'")
            ;;
        --help | -h | h)
            echo -e "$(basename "''${0}") [action]"
            echo "d :  drun mode"
            echo "w :  window mode"
            echo "f :  filebrowser mode,"
            echo "r :  run mode"
            exit 0
            ;;
        *)
            r_mode="drun"
            ROFI_LAUNCH_DRUN_STYLE="''${ROFI_LAUNCH_DRUN_STYLE:-$ROFI_LAUNCH_STYLE}"
            rofi_config="''${ROFI_LAUNCH_DRUN_STYLE:-$rofi_config}"
            ;;
        esac

        # Set visual overrides
        hypr_border=10
        hypr_width=2
        wind_border=$((hypr_border * 3))
        elem_border=$((hypr_border * 2))

        # Check monitor orientation
        mon_data=$(hyprctl -j monitors 2>/dev/null || echo '{"monitors":[]}')
        is_vertical=$(jq -e '.[] | select(.focused==true) | if (.transform % 2 == 0) then .width / .height else .height / .width end < 1' <<<"''${mon_data}" 2>/dev/null || echo "false")

        # Set style overrides
        r_override="window {border: ''${hypr_width}px; border-radius: ''${wind_border}px;} element {border-radius: ''${elem_border}px;}"

        # Set font name
        font_name=''${ROFI_LAUNCH_FONT:-$ROFI_FONT}
        font_name=''${font_name:-"JetBrainsMono Nerd Font"}

        # Set rofi font override
        font_override="* {font: \"''${font_name:-"JetBrainsMono Nerd Font"} ''${font_scale}\";}"
        i_override="configuration {icon-theme: \"Papirus\";}"

        # Check if style file exists with .rasi extension
        if [ ! -f "$rofiStyleDir/$rofi_config.rasi" ]; then
            echo "Warning: Style file '$rofiStyleDir/$rofi_config.rasi' not found, falling back to style_1"
            rofi_config="style_1"
        fi

        # Add style to rofi args
        rofi_args+=(
            -theme-str "''${font_override}"
            -theme-str "''${i_override}"
            -theme-str "''${r_override}"
            -theme "$rofiStyleDir/$rofi_config.rasi"
        )

        # Launch rofi
        rofi -show "''${r_mode}" "''${rofi_args[@]}" &
        disown
      '')
      ##____________________________________________________________
(writeShellScriptBin "copyRofiPreviews_Styles" ''
#!/bin/bash

TARGET="$HOME/.config/rofi/assets"
SOURCE="/etc/nixos/rofi/assets"
STYLES="/etc/nixos/rofi/styles"

  mkdir -p "$HOME/.config/rofi/assets"
  cp -r "$SOURCE/"* "$HOME/.config/rofi/assets"

mkdir -p "$HOME/.config/rofi/styles"
cp -r "$STYLES/"* "$HOME/.config/rofi/styles"

'')
      #Dock Toggle
      (pkgs.writeShellScriptBin "toggle-dock" ''
        #!/usr/bin/env bash

        # If any nwg-dock-hyprland process is running, kill it; otherwise, start one with arguments.
        if pgrep -f "nwg-dock-hyprland" >/dev/null; then
            pkill -f "nwg-dock-hyprland"
        else
            nwg-dock-hyprland -i 32 -w 5 -mb 10 -ml 10 -mr 10 -x -c "rofi -show drun" &
        fi


      '')

      #  (pkgs.writeShellScriptBin "toggle-hyprpanel" ''
      #         #!/usr/bin/env bash

      #         # If any hyprpanel process is running, kill it; otherwise, start one with arguments.
      #         if pgrep  "hyprpanel" >/dev/null; then
      #             pkill  "hyprpanel"
      #             pkill "swaync"
      #         else
      #             hyprpanel &
      #         fi

      #       '')

      #Keybinds Hint
      (pkgs.writeShellScriptBin "keybindings-hint" ''
        #!/bin/bash

        # Kill yad if present to not interfere with this binds
        pkill yad || true

        # Check if rofi is already running
        if pidof rofi > /dev/null; then
          pkill rofi
        fi

        # Define the config files
        KEYBINDS_CONF="$HOME/.config/hypr/hyprland.conf"

        # Combine the contents of the keybinds files and filter for only 'bind ='
        KEYBINDS=$(cat "$KEYBINDS_CONF" "$USER_KEYBINDS_CONF" | grep -E '^bind[[:space:]]*=')

        # Check for any keybinds to display
        if [[ -z "$KEYBINDS" ]]; then
            echo "No keybinds found."
            exit 1
        fi

        # Process keybindings:
        # 1. Remove 'bind' prefix and '=' sign
        # 2. Replace '$mainMod' with ''
        # 3. Remove 'exec' text
        MODIFIED_KEYBINDS=$(echo "$KEYBINDS" \
            | sed -E 's/^bind[[:space:]]*=[[:space:]]*//g' \
            | sed 's/\$mainMod//g' \
            | sed 's/, exec//g')

        # Use rofi to display the modified keybindings
        echo "$MODIFIED_KEYBINDS" | rofi -dmenu -i -p "Keybinds" -config ~/.config/rofi/config-keybinds.rasi

      '')

      #Rofi-wifi menu

      (pkgs.writeShellScriptBin "rofi-wifi" ''
        #!/bin/env bash

                notify-send "Getting list of available Wi-Fi networks..."
                # Get a list of available wifi connections and morph it into a nice-looking list
                wifi_list=$(nmcli --fields "SECURITY,SSID" device wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA*.?\S/ /g" | sed "s/^--/ /g" | sed "s/  //g" | sed "/--/d")

                connected=$(nmcli -fields WIFI g)
                if [[ "$connected" =~ "enabled" ]]; then
                  toggle="󰖪  Disable Wi-Fi"
                elif [[ "$connected" =~ "disabled" ]]; then
                  toggle="󰖩  Enable Wi-Fi"
                fi

                # Use rofi to select wifi network
                chosen_network=$(echo -e "$toggle\n$wifi_list" | uniq -u | rofi -dmenu -i -selected-row 1 -p "Wi-Fi SSID: " )
                # Get name of connection
                read -r chosen_id <<< "$chosen_network: 3"

                if [ "$chosen_network" = "" ]; then
                  exit
                elif [ "$chosen_network" = "󰖩  Enable Wi-Fi" ]; then
                  nmcli radio wifi on
                elif [ "$chosen_network" = "󰖪  Disable Wi-Fi" ]; then
                  nmcli radio wifi off
                else
                  # Message to show when connection is activated successfully
                    success_message="You are now connected to the Wi-Fi network \"$chosen_id\"."
                  # Get saved connections
                  saved_connections=$(nmcli -g NAME connection)
                  if [[ $(echo "$saved_connections" | grep -w "$chosen_id") = "$chosen_id" ]]; then
                    nmcli connection up id "$chosen_id" | grep "successfully" && notify-send "Connection Established" "$success_message"
                  else
                    if [[ "$chosen_network" =~ "" ]]; then
                      wifi_password=$(rofi -dmenu -p "Password: " )
                    fi
                    nmcli device wifi connect "$chosen_id" password "$wifi_password" | grep "successfully" && notify-send "Connection Established" "$success_message"
                    fi
                fi'')

      #Custom Rofi
      (pkgs.writeShellScriptBin "rofi-run" ''
                       
               #!/usr/bin/env bash

           # Default values
           dir="$HOME/.config/rofi/launchers/"

          #  type="/type-7" # Default folder
          #  theme='style-2' # Default rasi/config file

          #  #Some Good ones
          #  type="/type-1" 
          #  theme='style-5'

          #  type="/type-1" 
          #  theme='style-12' 

          #  type="/type-1" 
          #  theme='style-15'  

           type="/type-6" 
           theme='style-10'  

          #  type="/type-7" 
          #  theme='style-1' 

          #  type="/type-7" 
          #  theme='style-1' 

          #  type="/type-7" 
          #  theme='style-1' 




           

        ##_____________________________Dont touch this_____________________________________
                    # Detect the active Wayland socket (e.g., wayland-1)
                    ACTIVE_SOCKET=$(ls /run/user/$(id -u)/wayland-* | head -n 1)

                    # Check if WAYLAND_DISPLAY is set and matches the active socket
                    if [ "$WAYLAND_DISPLAY" != "$(basename "$ACTIVE_SOCKET")" ]; then
                      # If not, export the active socket as WAYLAND_DISPLAY
                      export WAYLAND_DISPLAY="$(basename "$ACTIVE_SOCKET")"
                      echo "WAYLAND_DISPLAY updated to: $WAYLAND_DISPLAY"
                    else
                      echo "WAYLAND_DISPLAY already set to: $WAYLAND_DISPLAY"
                    fi

                    # Output the current WAYLAND_DISPLAY to verify
                    echo "Using WAYLAND_DISPLAY: $WAYLAND_DISPLAY"
        ##__________________________________________________________________
        # Run rofi with the selected theme and display
        rofi \
            -show drun \
            -theme "$dir""$type"/"$theme".rasi



      '')

      (pkgs.writeShellScriptBin "rofi-powermenu" ''
        #!/usr/bin/env bash
        ## Rofi   : Power Menu

                  # Default values
                  dir=$HOME/.config/rofi/powermenu/   # No quotes for dir
                  type="/type-4"                      # Default folder
                  theme='style-1'                     # Default rasi/config file

                  # Current Theme
                  uptime="`uptime -p | sed -e 's/up //g'`"
                  host=`hostname`

                  # Options
                  shutdown=' Shutdown'
                  reboot=' Reboot'
                  lock=' Lock'
                  suspend=' Suspend'
                  logout=' Logout'
                  yes=' Yes'
                  no=' No'

        ###____________________________________________________________________
        # Detect the active Wayland socket
        ACTIVE_SOCKET=$(ls /run/user/$(id -u)/wayland-* | head -n 1)

        # Check if WAYLAND_DISPLAY is set and matches the active socket
        if [ "$WAYLAND_DISPLAY" != "$(basename "$ACTIVE_SOCKET")" ]; then
          # If not, export the active socket as WAYLAND_DISPLAY
          export WAYLAND_DISPLAY="$(basename "$ACTIVE_SOCKET")"
          echo "WAYLAND_DISPLAY updated to: $WAYLAND_DISPLAY"
        else
          echo "WAYLAND_DISPLAY already set to: $WAYLAND_DISPLAY"
        fi

        # Output the current WAYLAND_DISPLAY to verify
        echo "Using WAYLAND_DISPLAY: $WAYLAND_DISPLAY"
        ########_______________________________________________________________
        # Rofi CMD (Power Menu)
        rofi_cmd() {
                rofi -dmenu \
                        -p "Uptime: $uptime" \
                        -mesg "Uptime: $uptime" \
                        -theme "$dir"/"$type"/"$theme".rasi   # Updated line with the correct path format
        }

        # Confirmation CMD
        confirm_cmd() {
                rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;}' \
                        -theme-str 'mainbox {children: [ "message", "listview" ];}' \
                        -theme-str 'listview {columns: 2; lines: 1;}' \
                        -theme-str 'element-text {horizontal-align: 0.5;}' \
                        -theme-str 'textbox {horizontal-align: 0.5;}' \
                        -dmenu \
                        -p 'Confirmation' \
                        -mesg 'Are you Sure?' \
                        -theme "$dir"/"$type"/"$theme".rasi
        }







        # Ask for confirmation
        confirm_exit() {
        	echo -e "$yes\n$no" | confirm_cmd
        }

        # Pass variables to rofi dmenu
        run_rofi() {
        	echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
        }

        # Execute Command
        run_cmd() {
        	selected="$(confirm_exit)"
        	if [[ "$selected" == "$yes" ]]; then
        		if [[ $1 == '--shutdown' ]]; then
        			systemctl poweroff
        		elif [[ $1 == '--reboot' ]]; then
        			systemctl reboot
        		elif [[ $1 == '--suspend' ]]; then
        			mpc -q pause
        			amixer set Master mute
        			systemctl suspend
        		elif [[ $1 == '--logout' ]]; then
        			if [[ "$DESKTOP_SESSION" == 'openbox' ]]; then
        				openbox --exit
        			elif [[ "$DESKTOP_SESSION" == 'bspwm' ]]; then
        				bspc quit
        			elif [[ "$DESKTOP_SESSION" == 'i3' ]]; then
        				i3-msg exit
        			elif [[ "$DESKTOP_SESSION" == 'plasma' ]]; then
        				qdbus org.kde.ksmserver /KSMServer logout 0 0 0
        			fi
        		fi
        	else
        		exit 0
        	fi
        }

        # Actions
        chosen="$(run_rofi)"
        case "$chosen" in
            $shutdown)
        		run_cmd --shutdown
                ;;
            $reboot)
        		run_cmd --reboot
                ;;
            $lock)
        		if [[ -x '/usr/bin/betterlockscreen' ]]; then
        			betterlockscreen -l
        		elif [[ -x '/usr/bin/i3lock' ]]; then
        			i3lock
        		fi
                ;;
            $suspend)
        		run_cmd --suspend
                ;;
            $logout)
        		run_cmd --logout
                ;;
        esac

      '')

      #Song info
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

      (writeShellScriptBin "rainbow-borders" ''
            
            #!/bin/bash
        # /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
        # for rainbow borders animation

        function random_hex() {
            random_hex=("0xff$(openssl rand -hex 3)")
            echo $random_hex
        }

        # rainbow colors only for active window
        hyprctl keyword general:col.active_border $(random_hex)  $(random_hex) $(random_hex) $(random_hex) $(random_hex) $(random_hex) $(random_hex) $(random_hex) $(random_hex) $(random_hex)  270deg

        # rainbow colors for inactive window (uncomment to take effect)
        #hyprctl keyword general:col.inactive_border $(random_hex) $(random_hex) $(random_hex) $(random_hex) $(random_hex) $(random_hex) $(random_hex) $(random_hex) $(random_hex) $(random_hex) 270deg
      '')
  ];
}