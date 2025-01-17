## home.nix
{
  config,
  pkgs,
  inputs,
  lib,
  spicetify-nix,
  ...
}:

let 



  


###############################
# variable declaration section #
###############################

  # #for Spicitify
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};

  #For hyprland
  opacity = "0.95";

  #For waybar
  # custom = {
  #   font = "JetBrainsMono Nerd Font";
  #   fontsize = "12";
  #   primary_accent = "cba6f7"; # change these colour options to apply over on etire waybar
  #   secondary_accent = "89b4fa"; # change these colour options to apply over on etire waybar
  #   tertiary_accent = "f5f5f5"; # change these colour options to apply over on etire waybar
  #   background = "11111B"; # change these colour options to apply over on etire waybar
  #   opacity = ".85";
  #   cursor = "Bibata-Modern-Classic";
  #   palette = {
  #     primary_background_rgba = "rgba(94, 94, 199, 0.81)"; # change these colour options to apply over on etire waybar
  #     tertiary_background_hex = "314244"; # change these colour options to apply over on etire waybar
  #   };
  # };

  custom = {
    font = "JetBrainsMono Nerd Font";
    fontsize = "12";
    primary_accent = "@primary_accent";
    secondary_accent = "@secondary_accent";
    tertiary_accent = "@tertiary_accent";
    background = "@background";
    opacity = ".85";
    cursor = "Bibata-Modern-Classic";

    primary_background_rgba = "@primary_background";
    tertiary_background_hex = "@tertiary_background";
     A-colour = "@A-colour";  
     B-Colour = "@B-Colour";  
     C-colour = "@C-colour";  
     D-colour = "@D-colour";  
     E-colour = "@E-colour";  
     F-colour = "@F-colour";  
     G-colour = "@G-colour";  
     H-colour = "@H-colour";  
     I-colour = "@I-colour";  
     J-colour = "@J-colour";  
     K-colour = "@K-colour";

  };

  #Variables for wlogout
  wlog = {
    fntSize = "14";
    button_rad = "8";
    active_rad = "10";
    mgn = "5";
    hvr = "10";
    x_mgn = "5";
    y_mgn = "5";
    x_hvr = "10";
    y_hvr = "10";
    BtnCol = "{foreground}";
  };

in
{

  imports = [
    # For NixOS
    # inputs.spicetify-nix.nixosModules.default
    # For home-manager
    inputs.spicetify-nix.homeManagerModules.default
    ./pywal.nix
  ];

  home = {
    username = "vamsi";
    homeDirectory = "/home/vamsi";
    stateVersion = "24.11";

    packages = with pkgs; [
      # Add your user-specific packages here
      fastfetch
      nautilus
      xfce.thunar
      mission-center

      # bluetooth manager
      blueman
      # ntfs support
      ntfs3g

      themechanger

      # Wayland essentials
      hyprland
      waybar
      rofi-wayland
      #dunst
      grim
      slurp
      swww # Wallpaper setter
      wlogout
      waypaper
      # theme other apps
      nwg-look
      # volume, brightness modifier / display

      nwg-dock-hyprland
      cliphist
      hyprpolkitagent

      # System utilities
      eza
      fzf
      nix-output-monitor
      wl-clipboard
      fish
      showmethekey

      # Applications
      alacritty
      kitty
      neovim
      #firefox
      qbittorrent
      starship
      cmatrix
      bat
      meson
      hyprpicker
      ninja
      imv
      mpv
      obs-studio
      solaar
      #wallust
      pywal

      # music
      #spotify
      spicetify-cli

      # Additional utilities
      brightnessctl
      pamixer # Audio control
      networkmanagerapplet
      localsend

      #Productivity
      hugo
      glow

      # dev tools
      #postman
      nixfmt-rfc-style
      #mongodb-compass

      #User Apps
      celluloid
      discord
      librewolf
      cool-retro-term
      bibata-cursors
      vscode
      lollypop
      lutris
      #openrgb
      betterdiscord-installer

      #utils
      ranger
      wlr-randr
      superfile
      yazi
      lazygit
      zoxide
      pipes-rs
      rsclock

      swaynotificationcenter # notification service
      flameshot
      warp-terminal

      gcc
      rustup
      gnumake
      catimg
      curl
      appimage-run
      xflux

      sqlite

      #misc
      cava

      #nano
      cmatrix

      #using in waybar
      playerctl
      pavucontrol

      mullvad-closest

      nitch # neoftch like

      yubikey-manager

      #Themes
      numix-icon-theme-circle
      colloid-icon-theme
      catppuccin-gtk
      catppuccin-kvantum
      wpgtk # gtk auto theme to wallpaper
      # catppuccin-cursors.macchiatoTeal

      pamixer
      mpc-cli
      tty-clock
      btop
      tokyo-night-gtk


      ##Scripts
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

    ];
  };

  
 home.file = {

  ##############
  ##Key Binds###
  ##############
# Ensure the custom Rofi config is placed in the expected directory
  ".config/rofi/config-keybinds.rasi" = {
    text = ''
 @import "~/.config/rofi/config.rasi"

    /* ---- Entry ---- */
    entry {
      width: 85%;
      placeholder: ' 🧮 Search Keybinds NOTE "ESC will close this app  " "=" "SUPER KEY is (Windows Key)" ';
      
    }

    /* ---- Listview ---- */
    listview {
      columns: 2;
      lines: 12;
    }

    window {
        width: 95%;
    }
  '';
  };
 };

  # Enable Mullvad VPN
  # services.mullvad-vpn.enable = true;
  # services.mullvad-vpn.package = pkgs.mullvad-vpn; # `pkgs.mullvad` only provides the CLI tool, use `pkgs.mullvad-vpn` instead if you want to use the CLI and the GUI.

  ##Yubi key
  #services.udev.packages = [ pkgs.yubikey-personalization ];

  #  programs.ssh.startAgent = true;

  # FIXME Don't forget to create an authorization mapping file for your user (https://nixos.wiki/wiki/Yubikey#pam_u2f)
  #  security.pam.u2f = {
  #    enable = true;
  #    settings.cue = true;
  #    control = "sufficient";
  #  };

  #  security.pam.services = {
  #    greetd.u2fAuth = true;
  #    sudo.u2fAuth = true;
  #    hyprlock.u2fAuth = true;
  #  };

  #Hypridle config
  #  services.hypridle = {
  #    enable = true;
  #    settings = {
  #      general = {
  #        before_sleep_cmd = "loginctl lock-session";
  #        after_sleep_cmd = "hyprctl dispatch dpms on";
  #        ignore_dbus_inhibit = false;
  #        lock_cmd = "pidof hyprlock || hyprlock";
  #      };

  #      listener = [
  #        {
  #          timeout = 180;
  #          on-timeout = "brightnessctl -s set 30";
  #          on-resume = "brightnessctl -r";
  #        }
  #        {
  #          timeout = 300;
  #          on-timeout = "loginctl lock-session";
  #        }
  #        {
  #          timeout = 600;
  #          on-timeout = "hyprctl dispatch dpms off";
  #          on-resume = "hyprctl dispatch dpms on";
  #        }
  #        {
  #          timeout = 1200;
  #          on-timeout = "sysemctl suspend";
  #        }
  #      ];
  #    };
  #  };

  #Sway Notification center configruration
  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      #control-center-radius = 1;
      control-center-margin-top = 10;
      control-center-margin-bottom = 10;
      control-center-margin-right = 10;
      control-center-margin-left = 10;
      fit-to-screen = true;
      layer-shell = true;
      layer = "overlay";
      control-center-layer = "overlay";
      cssPriority = "user";
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      timeout = 10;
      timeout-low = 5;
      timeout-critical = 0;

      #fit-to-screen = false;
      control-center-width = 450;
      control-center-height = 600;
      notification-window-width = 450;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = false;
      hide-on-action = true;
      script-fail-notify = true;

      widgets = [
        "inhibitors"
        "dnd"
        "backlight"
        "volume"
        "buttons-grid"
        "mpris"
        "notifications"
        "title"

      ];
      widget-config = {
        title = {
          text = "Notifications 󱅫";
          clear-all-button = true;
          button-text = "󰆴 Clear All";
        };
        dnd = {
          text = "Do Not Disturb";
        };
        label = {
          max-lines = 1;
          text = "Notifications 󰂚";
        };
        mpris = {
          image-size = 96;
          image-radius = 7;
          blur = true;
        };
        volume = {
          label = "󰕾";
        };
        backlight = {
          label = "󰃟";
          device = "nvidia_0";
          subsystem = "backlight";
        };

        buttons-grid = {
          actions = [
            {
              label = "⏹️";
              command = "systemctl poweroff";
               tooltip = "Power Off";
            }
            {
              label = "🔄";
              command = "systemctl reboot";
              tooltip = "Reboot";
            }
            {
              label = "🚪";
              command = "hyprctl dispatch exit";
               tooltip = "Exit Sway";
            }
            {
              label = "🗃️";
              command = "thunar";
              tooltip = "Open File Manager";
            }
            {
              label = "📸";
              command = "gimp";
              tooltip = "Launch GIMP";
            }
            {
              label = "📣";
              command = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
              tooltip = "Toggle Mute";
            }
            {
              label = "🎙️";
              command = "pactl set-source-mute @DEFAULT_SOURCE@ toggle";
              tooltip = "Toggle Microphone";
            }
            {
              label = "🎮";
              command = "steam";
              tooltip = "Launch Steam";
            }
            {
              label = "🌏";
              command = "firefox";
              tooltip = "Open Firefox";
            }
            {
              label = "📹";
              command = "obs";
              tooltip = "Start OBS";
            }
          ];
        };

      };

    };


 style='' 
       @import url("$HOME/.cache/wal/colors-swaync.css");

       * {
         font-family: "JetBrainsMono Nerd Font"; 
         font-weight: normal; 
       }

       .control-center { 
         background: var(--background); 
         border-radius: 10px; 
         border: 2px solid var(--border); 
         margin: 10px; 
         padding: 5px; 
       }

       .notification-content { 
         background: var(--background); 
         border-radius: 10px; 
         border: 2px solid var(--accent); 
         margin: 5px; 
       }

       .close-button { 
         background: var(--primary); 
         color: var(--background); 
         text-shadow: none; 
         padding: 0 5px; 
         border-radius: 5px; 
       }

       .close-button:hover { 
         background: var(--accent); 
       }

       .widget-title { 
         color: var(--secondary); 
         font-size: 1.5rem; 
         margin: 10px; 
         font-weight: bold; 
       }

       .buttons-grid > button:hover { 
         background: var(--accent); 
         color: var(--background); 
       }
     '';
    # style = ''
    #        @import url("../../.cache/wal/colors-swaync.css");
    #       * {
    #         font-family: "JetBrainsMono Nerd Font";
    #         font-weight: normal;
    #       }

    #       .control-center {
    #         background: rgba(0, 0, 0, 0.7);
    #         border-radius: 10px;
    #         border: 2px solid #cba6f7;
    #         margin: 10px;
    #         padding: 5px;
    #       }

    #       .notification-row:focus,
    #       .notification-row:hover {
    #         background: rgba(0, 0, 0, 0.5);
    #       }

    #       .notification {
    #         background: transparent;
    #         padding: 0;
    #         margin: 0px;
    #       }

    #       .notification-content {
    #         background: rgba(0, 0, 0, 0.5);
    #         padding: 10px;
    #         border-radius: 10px;
    #         border: 2px solid #89b4fa;
    #         margin: 5px;
    #       }

    #       .close-button {
    #         background: #f38ba8;
    #         color: #11111b;
    #         text-shadow: none;
    #         padding: 0 5px;
    #         border-radius: 5px;
    #       }

    #       .close-button:hover {
    #         background: #89b4fa;
    #       }

    #       .widget-title {
    #         color: #a6e3a1;
    #         font-size: 1.5rem;
    #         margin: 10px;
    #         font-weight: bold;
    #       }

    #       .widget-title button {
    #         font-size: 1rem;
    #         color: #cdd6f4;
    #         background: rgba(0, 0, 0, 0.3);
    #         border-radius: 5px;
    #       }

    #       .widget-dnd {
    #         background: rgba(0, 0, 0, 0.3);
    #         padding: 5px 10px;
    #         margin: 5px;
    #         border-radius: 10px;
    #         font-size: large;
    #         color: #a6e3a1;
    #       }

    #       .widget-dnd > switch {
    #         background: #a6e3a1;
    #         border-radius: 5px;
    #       }

    #       .widget-dnd > switch:checked {
    #         background: #f38ba8;
    #       }

    #       .widget-mpris {
    #         background: rgba(0, 0, 0, 0.3);
    #         padding: 5px;
    #         margin: 5px;
    #         border-radius: 10px;
    #       }

    #       .widget-mpris button {
    #         border-radius: 5px;
    #       }

    #       .buttons-grid {
    #         font-size: x-large;
    #         padding: 5px;
    #         margin: 5px;
    #         border-radius: 10px;
    #         border:5px;
    #         background: rgba(0, 0, 0, 0.3);
    #       }

    #       .buttons-grid > button {
    #     margin: 3px;
    #     background: rgba(0, 0, 0, 0.3);
    #     border-radius: 5px;
    #     color: #cdd6f4;
    #     transition: transform 0.2s ease, background 0.3s ease;
    #     position: relative;
    #   }


    #       .buttons-grid > button:hover {
    #         background: #89b4fa;
    #         color: #11111b;
    #         transform: scale(1.2);
    #       }

    #   /* Tooltip styling */
    #   .buttons-grid > button::after {
    #     content: attr(data-tooltip);
    #     position: absolute;
    #     bottom: 110%;
    #     left: 50%;
    #     transform: translateX(-50%);
    #     background: rgba(0, 0, 0, 0.8);
    #     color: #ffffff;
    #     padding: 5px 8px;
    #     border-radius: 4px;
    #     white-space: nowrap;
    #     opacity: 0;
    #     pointer-events: none;
    #     transition: opacity 0.3s ease;
    #     font-size: 0.75rem;
    #   }

    #       .widget-backlight, .widget-volume {
    #         background: rgba(0, 0, 0, 0.3);
    #         padding: 5px;
    #         margin: 5px;
    #         border-radius: 10px;
    #       }

    #       .buttons-grid > button:hover::after {
    #     opacity: 1;
    #   }

    #       .widget-backlight > box > button,
    #       .widget-volume > box > button {
    #         background: #a6e3a1;
    #         border: none;
    #       }
    # '';
  };


 

  programs = {

    # vscode = {
    #   enable = true;
    #   userSettings = {
    #     # This property will be used to generate settings.json:
    #     # https://code.visualstudio.com/docs/getstarted/settings#_settingsjson
    #     "editor.formatOnSave" = true;
    # };
    #   extensions =
    #     with pkgs.vscode-extensions;
    #     [
    #       # Default extensions
    #       bbenoist.nix
    #     ]
    #     ++ vscode-marketplace [

    #     ];
    # };

    #My Waybar configuration
    waybar = {
      enable = true;
      settings.mainBar = {
        position = "top";
        layer = "top";
        height = 50;
        margin-top = 0;
        margin-bottom = 0;
        margin-left = 0;
        margin-right = 0;

        modules-left = [
          "custom/launcher"

          "custom/wallchange"
          "custom/themechange"
          "custom/playerctl#backward"
          "custom/playerctl#play"
          "custom/playerctl#foward"
          "custom/playerlabel"
          "hyprland/window"
          "wlr/taskbar"

        ];

        modules-center = [
          #removed cava as i am not realy using it
          #"cava#left"
          "hyprland/workspaces"
          #"cava#right"

        ];

        modules-right = [

          #"custom/padd"
          #"custom/l_end"

          "battery"
          "network"

          ##grouped##
          "cpu"
          "memory"
          "disk"
          "custom/cliphist"
          "custom/keybindhint"
          "pulseaudio"
          ############

          "custom/notifications"
          "backlight"
          "clock"
          "tray"
          "custom/power"
          # "custom/r_end"
          # "custom/padd"
        ];

        #modules for padding

        "custom/l_end" = {
          format = " ";
          interval = "once";
          tooltip = false;
        };

        "custom/r_end" = {
          format = " ";
          interval = "once";
          tooltip = false;
        };
        "custom/padd" = {
          format = "  ";
          interval = "once";
          tooltip = false;
        };

        "custom/notifications" = {
          tooltip = false;
          format = "{icon} {}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "sleep 0.1 && swaync-client -t";
          escape = true;
        };

        clock = {
          #format = " {:%a, %d %b, %I:%M %p}";
          format = " {:%I:%M %p}";
          tooltip = "true";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          #format-alt = " {:%d/%m}";
          format-alt = " {:%a, %d %b, %I:%M %p}";
        };
        # "wlr/workspaces" = {
        #   active-only = false;
        #   all-outputs = false;
        #   disable-scroll = false;
        #   on-scroll-up = "hyprctl dispatch workspace e-1";
        #   on-scroll-down = "hyprctl dispatch workspace e+1";
        #   format = "{name}";
        #   on-click = "activate";

        #   format-icons = {
        #     urgent = "";
        #     active = "";
        #     default = "";
        #     sort-by-number = true;
        #   };
        # };
        "hyprland/workspaces" = {
          format = "{name}";
          format-icons = {
            default = " ";
            active = " ";
            urgent = " ";
            
          };
          persistent-workspaces = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
          };
          sort-by-number = true;
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };

        
        "hyprland/window" = {
          format = "{icon} {title}";
          separate-outputs = true;
          max-length = 25;
        };
        "wlr/taskbar" = {
          format = "{icon}";
          icon-size = 18;
          # icon-theme = "Tela-circle-dracula";
          #       "spacing" =  0;
          tooltip = true;
          tooltip-format = "{title}";
          on-click = "activate";
          on-click-middle = "close";
          active-first = true;
          ignore-list = [
            "Alacritty"
            "kitty"
          ];
          app_ids-mapping = {
            "firefoxdeveloperedition" = "firefox-developer-edition";
          };
        };

        "cava#left" = {
          framerate = 60;
          autosens = 1;
          bars = 18;
          lower_cutoff_freq = 50;
          higher_cutoff_freq = 10000;
          method = "pipewire";
          source = "auto";
          stereo = true;
          reverse = false;
          bar_delimiter = 0;
          monstercat = false;
          waves = false;
          input_delay = 1;
          max-length = 10;
          format-icons = [
            "<span foreground='#${custom.primary_accent}'>▁</span>"
            "<span foreground='#${custom.primary_accent}'>▂</span>"
            "<span foreground='#${custom.primary_accent}'>▃</span>"
            "<span foreground='#${custom.primary_accent}'>▄</span>"
            "<span foreground='#${custom.secondary_accent}'>▅</span>"
            "<span foreground='#${custom.secondary_accent}'>▆</span>"
            "<span foreground='#${custom.secondary_accent}'>▇</span>"
            "<span foreground='#${custom.secondary_accent}'>█</span>"
          ];
        };
        "cava#right" = {
          framerate = 60;
          autosens = 1;
          bars = 18;
          lower_cutoff_freq = 50;
          higher_cutoff_freq = 10000;
          method = "pipewire";
          source = "auto";
          stereo = true;
          reverse = false;
          bar_delimiter = 0;
          monstercat = false;
          waves = false;
          input_delay = 1;
          max-length = 10;
          format-icons = [
            "<span foreground='#${custom.primary_accent}'>▁</span>"
            "<span foreground='#${custom.primary_accent}'>▂</span>"
            "<span foreground='#${custom.primary_accent}'>▃</span>"
            "<span foreground='#${custom.primary_accent}'>▄</span>"
            "<span foreground='#${custom.secondary_accent}'>▅</span>"
            "<span foreground='#${custom.secondary_accent}'>▆</span>"
            "<span foreground='#${custom.secondary_accent}'>▇</span>"
            "<span foreground='#${custom.secondary_accent}'>█</span>"
          ];
        };
        "custom/playerctl#backward" = {
          format = "󰙣 ";
          on-click = "playerctl previous";
          on-scroll-up = "playerctl volume .05+";
          on-scroll-down = "playerctl volume .05-";
        };
        "custom/playerctl#play" = {
          format = "{icon}";
          return-type = "json";
          exec = "playerctl -a metadata --format '{\"text\": \"{{artist}} - {{markup_escape(title)}}\", \"tooltip\": \"{{playerName}} : {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F";
          on-click = "playerctl play-pause";
          on-scroll-up = "playerctl volume .05+";
          on-scroll-down = "playerctl volume .05-";
          format-icons = {
            Playing = "<span>󰏥 </span>";
            Paused = "<span> </span>";
            Stopped = "<span> </span>";
          };
        };
        "custom/playerctl#foward" = {
          format = "󰙡 ";
          on-click = "playerctl next";
          on-scroll-up = "playerctl volume .05+";
          on-scroll-down = "playerctl volume .05-";
        };
        "custom/playerlabel" = {
          format = "<span>󰎈 {} 󰎈</span>";
          return-type = "json";
          max-length = 20;
          exec = "playerctl -a metadata --format '{\"text\": \"{{artist}} - {{markup_escape(title)}}\", \"tooltip\": \"{{playerName}} : {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F";
          on-click = "";
        };
        battery = {
          interval = 1;
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{icon}{capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󱘖 {capacity}%";
          format-alt = "{icon} {time}";
          format-icons = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };

        memory = {
          format = " {}%";
          format-alt = " {used}/{total} GiB";
          interval = 5;
          tooltip = true;
        };
        cpu = {
          format = "󰻠 {usage}%";
          format-alt = "󰻠 {avg_frequency} GHz";
          interval = 5;
        };
        disk = {
          format = " {free}";
          tooltip = true;
        };
        network = {
          tooltip = true;
          format-wifi = " {signalStrength}%";
          rotate = 0;
          format-ethernet = "󰈀 100% ";
          tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
          format-linked = "{ifname} (No IP)";
          format-disconnected = "󰖪 0% ";
          interval = 2;
          on-click = "nm-applet --indicator";
        };

        tray = {
          icon-size = 20;
          spacing = 5;
        };
        pulseaudio = {
          interval = 1;
          format = "{icon} {volume}% {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = " {volume}%";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "sleep 0.1 && pavucontrol";
        };

        backlight = {
          device = "intel_backlight";
          rotate = 0;
          format = "{icon} {percent}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
          ];
          on-scroll-up = "brightnessctl set 1%+";
          on-scroll-down = "brightnessctl set 1%-";
          min-length = 6;
        };

        "custom/power" = {
          format = "{}";
          rotate = 0;
          #exec = "echo ; echo  logout";
          on-click = "wlogout";
          #on-click-right = "logoutlaunch.sh 1";
          #interval = 86400; # once every day
          tooltip = true;
        };

        "custom/cliphist" = {
          format = "{}";
          rotate = 0;
          #exec = "echo ; echo 󰅇 clipboard history";
          on-click = "sleep 0.1 && cliphist list | rofi -dmenu | cliphist decode | wl-copy";
          #on-click-right = "sleep 0.1 && cliphist.sh d";
          #on-click-middle = "sleep 0.1 && cliphist.sh w";
          #interval  = 86400; # once every day
          tooltip = true;
        };

        "custom/keybindhint" = {
          format = " ";
          rotate = 0;
          on-click = "keybindings-hint";
        };

        "custom/wallchange" = {
          format = "󰸉";
          rotate = 0;
          # on-click = "waypaper";
          on-click = "waypaper --random";
          #"interval" = 86400, # once every day;
          tooltip = true;
        };
        "custom/themechange" = {
          format = "";
          rotate = 0;
          on-click = "theme-reload";
          #"interval" = 86400, # once every day;
          tooltip = true;
        };

        "custom/launcher" = {
          format = "";
          on-click = "rofi -show drun";
          tooltip = "false";
        };
      };
      style = ''
         @import url("../../.cache/wal/colors-waybar.css");

          * {
              border: none;
              border-radius: 0px;
              font-family: ${custom.font};
              font-size: 14px;
              min-height: 0;
             }


         /*  window#waybar {
                background: transparent;
           }*/
                   
        /* window#waybar {
          background:  rgba(0,9,15,0.25);
            border-radius: 4px;
          }
          */

        window#waybar {
          background-color: rgba(26, 27, 38, 0.5);
          color: #ffffff;
          transition-property: background-color;
          transition-duration: 0.5s;
          border-top: 8px transparent;
          border-radius: 8px;
          transition-duration: 0.5s;
          margin: 16px 16px;
        }


        tooltip {
         background: ${custom.tertiary_background_hex};
         color: ${custom.primary_accent};
         border-radius: 7px;
         border-width: 0px;
               }

      #cava.left, #cava.right {
          background: ${custom.tertiary_background_hex};
          margin: 5px; 
          padding: 8px 16px;
          color: ${custom.primary_accent};
      }
      #cava.left {
          border-radius: 24px 10px 24px 10px;
      }
      #cava.right {
          border-radius: 10px 24px 10px 24px;
      }
      #workspaces {
          background: ${custom.tertiary_background_hex};
          margin: 5px 5px;
          padding: 8px 5px;
          border-radius: 16px;
          color: ${custom.primary_accent}
          }
      #workspaces button {
          padding: 0px 5px;
          margin: 0px 3px;
          border-radius: 16px;
         /* color: transparent;*/
          color: ${custom.primary_accent}; 
            /*  background: ${custom.tertiary_background_hex};*/
              background: ${custom.primary_background_rgba};
              transition: all 0.3s ease-in-out;
          }
                      



     #workspaces button.active {
         background-color: ${custom.secondary_accent};
          color: ${custom.background}; 
         border-radius: 16px;
         min-width: 50px;
         background-size: 400% 400%;
         transition: all 0.3s ease-in-out;
     }

      #workspaces button:hover {
          background-color: ${custom.tertiary_accent};
          color: ${custom.background};
          border-radius: 16px;
          min-width: 50px;
          background-size: 400% 400%;
      }

                      
    #custom-playerctl.backward, #custom-playerctl.play, #custom-playerctl.foward{
        background: ${custom.tertiary_background_hex};
        font-weight: bold;
        margin: 5px 0px;
    }
    #tray  {
        color: ${custom.tertiary_accent};
        background: ${custom.tertiary_background_hex};
        border-radius: 10px 24px 10px 24px;
        padding: 2px 10px;
        margin: 4px;
        margin-left: 7px;
    }
    #clock {
        color: ${custom.tertiary_accent};
        background: ${custom.tertiary_background_hex};
        margin: 4px;
        padding: 2px 10px;
        border-radius: 10px;
        font-weight: bold;
        font-size: 16px;
    }
    #custom-launcher {
        color: ${custom.A-colour};
        background: ${custom.tertiary_background_hex};
        
        border-radius: 0px 0px 30px 0px;
        margin: 0px;
        padding: 0px 30px 0px 12px;
        font-size: 28px;
     }
       #custom-notifications{
       color: ${custom.C-colour};
        background: ${custom.tertiary_background_hex};
        margin: 4px;
        padding: 2px 6px;
        /* border-radius: 10px 24px 10px 24px; */
        border-radius: 20px;
        font-weight: bold;
        font-size: 16px;
       }

      #custom-launcher:hover {
         background-color: ${custom.primary_accent};
         color: ${custom.background};
         transition: all 0.3s ease-in-out;
      }


      #custom-playerctl.backward, #custom-playerctl.play, #custom-playerctl.foward {
          background: ${custom.tertiary_background_hex};
          font-size: 22px;
      }
      #custom-playerctl.backward:hover, #custom-playerctl.play:hover, #custom-playerctl.foward:hover{
          color: ${custom.tertiary_accent};
      }
      #custom-playerctl.backward {
          color: ${custom.primary_accent};
          border-radius: 24px 0px 0px 10px;
          padding-left: 16px;
          margin-left: 7px;
      }
      #custom-playerctl.play {
          color: ${custom.secondary_accent};
          padding: 0 5px;
      }
      #custom-playerctl.foward {
          color: ${custom.primary_accent};
          border-radius: 0px 10px 24px 0px;
          padding-right: 12px;
          margin-right: 7px
      }
      #custom-playerlabel {
          background: ${custom.tertiary_background_hex};
          color: ${custom.tertiary_accent};
          padding: 0 20px;
          border-radius: 24px 10px 24px 10px;
          margin: 5px 0;
          font-weight: bold;
      }
     #window {
        background: ${custom.tertiary_background_hex};
        color: ${custom.tertiary_accent};
        padding: 0px 10px;
        margin: 5px;
        border-radius: 16px;
        font-weight: normal;
      }

    #taskbar {
      background: ${custom.tertiary_background_hex};
      margin: 5px;
      padding: 2px;
      border-radius: 16px;
    }

    #taskbar button {
      padding: 0px 5px;
      margin: 0px 3px;
      border-radius: 16px;
      color: ${custom.primary_accent};
      background: transparent;
      animation: tb_normal 20s ease-in-out 1;
    }

    #taskbar button.active {
      background-color: ${custom.secondary_accent};
      color: ${custom.background};
      margin-left: 3px;
      padding-left: 12px;
      padding-right: 12px;
      margin-right: 3px;
      animation: tb_active 20s ease-in-out 1;
    }
     #custom-wallchange,#custom-themechange
     {
        background: ${custom.tertiary_background_hex};
        color: ${custom.tertiary_accent};
        border-radius: 50px 50px 50px 50px;
        padding: 0 20px;
        margin: 5px 7px;
        font-weight: bold;
      }
      #custom-wallchange:hover,#custom-themechange:hover{
                    color: ${custom.secondary_accent};
                    }
    
    #custom-r_end {
        border-radius: 0px 21px 21px 0px;
        margin-right: 9px;
        padding-right: 3px;
    }

    #custom-l_end {
        border-radius: 21px 0px 0px 21px;
        margin-left: 9px;
        padding-left: 3px;
    }

      
    #custom-power,#network, #battery , #backlight
     {
        background: ${custom.tertiary_background_hex};
        
        /* border-radius: 10px 24px 10px 24px; */
        border-radius: 16px;
        padding: 0 20px;
        margin: 5px 7px;
        font-weight: bold;
      }


      #custom-power {
      color: ${custom.A-colour};
        padding: 0 15px;
        font-size: 16px;
      }


      #backlight {
      color: ${custom.B-Colour};
        padding: 0 8px;
        font-size: 10px;
      }

      #network {
      color: ${custom.C-colour};
        padding: 0 8px;
        font-size: 12px;
      }
         #battery {
         color: ${custom.D-colour};
        padding: 0 6px;
        font-size: 10px;
      }
        


    #cpu,#disk,#network, #memory, #custom-cliphist, #custom-keybindhint, #pulseaudio {
      background: ${custom.tertiary_background_hex};
      font-weight: bold;
      
    }


    #cpu {
        color: ${custom.G-colour};
        margin: 4px 0px;
    	  padding: 2px 5px 2px 10px;
    	  border-radius: 10px 0px 0px 20px;
    }

    #memory, #custom-cliphist, #custom-keybindhint,#disk {
      color: ${custom.E-colour};
      margin: 4px 0px;
      padding: 2px 14px;
      border-radius: 0px;
     }
 
    #memory{
      color:${custom.H-colour};
      } 
    
    #custom-cliphist{
      color:${custom.I-colour};
      } 
    
    #custom-keybindhint{
      color:${custom.K-colour};
      }
    
    #disk{
      color:${custom.J-colour};
      }


    #pulseaudio {
              color: ${custom.A-colour};
    	  margin: 4px 0px;
    	  padding: 2px 10px 2px 5px;
    	  border-radius: 0px 20px 10px 0px;
    }
           






      '';
    };

    # waypaper = {
    #     enable = true;
    #     package = pkgs.waypaper;
    #     settings = {
    #       restore_last = true;
    #       post_command = "theme-reload";
    #     };
    #   };

    # Git configuration
    git = {
      enable = true;
      userName = "vamsi";
      userEmail = "n.vamsi9955@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };

    # Shell configurations
    #starship.enable = true;
    # bash = {
    #  enable = true;
    #  enableCompletion = true;
    # };

    # Terminal configuration
    alacritty = {
      enable = true;
      settings = {
        general.import = [
          "~/.config/alacritty/colors.toml"
        ];
        window = {
          padding = {
            x = 10;
            y = 10;
          };
          opacity = 0.95;
        };
        font = {
          normal = {
            family = "JetBrainsMono Nerd Font";
            style = "Regular";
          };
          size = 11.0;
        };

      };
    };

    # Terminal configuration
    kitty = {
      enable = true;
      shellIntegration = {
        enableZshIntegration = true;
        mode = "no-cursor";
      };
      # https://www.monolisa.dev/faq#how-to-enable-stylistic-sets-for-the-kitty-terminal
      extraConfig = ''
        font_features MonoLisa -calt +liga +zero +ss01 +ss02 +ss07 +ss08 +ss10 +ss11 +ss18
        modify_font cell_width 100%
        modify_font cell_height 100%

        # Import pywal colors
        include ~/.cache/wal/colors-kitty.conf
      '';
      settings = {
        bold_font = "auto";
        italic_font = "auto";
        bold_italic_font = "auto";

        # modify_font underline_position 4
        # modify_font underline_thickness 150%
        text_composition_strategy = "platform"; # platform or legacy
        sync_to_monitor = "yes";

        # Background
        background_opacity = "0.8";

        # Cursor
        cursor_shape = "block";
        cursor_blink_interval = 0;
        cursor_trail = 1;

        # Don't ask for confirmation when closing a tab.
        confirm_os_window_close = 0;
        disable_ligatures = "never";

        copy_on_select = "clipboard";
        clear_all_shortcuts = true;
        draw_minimal_borders = "yes";
        input_delay = 0;
        kitty_mod = "ctrl+shift";

        # Mouse
        mouse_hide_wait = 10;
        url_style = "double";

        # Shhhhh
        enable_audio_bell = false;
        visual_bell_duration = 0;
        window_alert_on_bell = false;
        bell_on_tab = false;
        command_on_bell = "none";

        # Better colors
        term = "xterm-256color";

        # Themes
        # include = "themes/custom-mocha.conf";
        # include = "themes/oxocarbon-dark.conf";
        # terminal_select_modifiers = "alt";

        # Padding
        window_padding_width = 10;

        # Tab Bar
        tab_bar_edge = "top";
        tab_bar_margin_width = 5;
        tab_bar_margin_height = "5 0";
        tab_bar_style = "separator";
        tab_bar_min_tabs = 2;
        # tab_separator = "";
        tab_title_template = "{fmt.fg._5c6370}{fmt.bg.default}{fmt.fg._abb2bf}{fmt.bg._5c6370} {tab.active_oldest_wd} {fmt.fg._5c6370}{fmt.bg.default} ";
        active_tab_title_template = "{fmt.fg._BAA0E8}{fmt.bg.default}{fmt.fg.default}{fmt.bg._BAA0E8} {tab.active_oldest_wd} {fmt.fg._BAA0E8}{fmt.bg.default} ";
        # tab_bar_edge = "bottom";
        # tab_bar_style = "powerline";
        # tab_powerline_style = "slanted";
        # active_tab_title_template = "{index}: {title}";
        # active_tab_font_style = "bold-italic";
        # inactive_tab_font_style = "normal";

        # repaint_delay = 8;
      };
      keybindings = {
        "ctrl+shift+c" = "copy_to_clipboard";
        "ctrl+shift+v" = "paste_from_clipboard";
        "ctrl+shift+s" = "paste_from_selection";
        "ctrl+shift+e" = "open_url";
        "ctrl+shift+=" = "increase_font_size";
        "ctrl+shift+-" = "decrease_font_size";
        "ctrl+shift+backspace" = "restore_font_size";
        "ctrl+shift+up" = "scroll_line_up";
        "ctrl+shift+k" = "scroll_line_up";
        "ctrl+shift+down" = "scroll_line_down";
        "ctrl+shift+j" = "scroll_line_down";
        "ctrl+shift+home" = "scroll_home";
        "ctrl+shift+n" = "new_os_window";
        "ctrl+shift+]" = "next_window";
        "ctrl+shift+[" = "previous_window";
        "ctrl+shift+right" = "next_tab";
        "ctrl+tab" = "next_tab";
        "ctrl+shift+tab" = "previous_tab";
        "ctrl+shift+left" = "previous_tab";
        "ctrl+shift+t" = "new_tab";
        "ctrl+shift+q" = "close_tab";
      };
    };

    #EZA ls replacement
    eza = {
      enable = true;
      enableZshIntegration = true;
      colors = "always";
      git = true;
      icons = "always";
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
    };

    #LazyGit
    lazygit = {
      enable = true;
      settings = {
        gui.showIcons = true;
        gui.theme = {
          lightTheme = false;
          activeBorderColor = [
            "green"
            "bold"
          ];
          inactiveBorderColor = [ "grey" ];
          selectedLineBgColor = [ "blue" ];
        };
      };
    };

btop = {
  enable = true;
  settings = {
    color_theme = "pywal";
    theme_background = false;
    vim_keys = true;
    rounded_corners = true;
    graph_symbol = "braille";
    shown_boxes = "cpu mem net proc";
    update_ms = 1000;
  };
};




    #Starship
    starship = {
      enable = true;
      settings = {
        "$schema" = "https://starship.rs/config-schema.json";

        format = "[](surface0)$os$username[](bg:peach fg:surface0)$directory[](fg:peach bg:green)$git_branch$git_status[](fg:green bg:teal)$c$rust$golang$nodejs$php$java$kotlin$haskell$python[](fg:teal bg:blue)$docker_context[](fg:blue bg:purple)$time[ ](fg:purple)$line_break$character";

        palette = "catppuccin_mocha";

        palettes.catppuccin_mocha = {
          rosewater = "#f5e0dc";
          flamingo = "#f2cdcd";
          pink = "#f5c2e7";
          orange = "#cba6f7";
          red = "#f38ba8";
          maroon = "#eba0ac";
          peach = "#fab387";
          yellow = "#f9e2af";
          green = "#a6e3a1";
          teal = "#94e2d5";
          sky = "#89dceb";
          sapphire = "#74c7ec";
          blue = "#89b4fa";
          lavender = "#b4befe";
          text = "#cdd6f4";
          subtext1 = "#bac2de";
          subtext0 = "#a6adc8";
          overlay2 = "#9399b2";
          overlay1 = "#7f849c";
          overlay0 = "#6c7086";
          surface2 = "#585b70";
          surface1 = "#45475a";
          surface0 = "#313244";
          base = "#1e1e2e";
          mantle = "#181825";
          crust = "#11111b";
        };

        os = {
          disabled = false;
          style = "bg:surface0 fg:text";

          symbols = {
            Windows = "󰍲";
            Ubuntu = "󰕈";
            SUSE = "";
            Raspbian = "󰐿";
            Mint = "󰣭";
            Macos = "";
            Manjaro = "";
            Linux = "󰌽";
            Gentoo = "󰣨";
            Fedora = "󰣛";
            Alpine = "";
            Amazon = "";
            Android = "";
            Arch = "󰣇";
            Artix = "󰣇";
            CentOS = "";
            Debian = "󰣚";
            Redhat = "󱄛";
            RedHatEnterprise = "󱄛";
            NixOS = " ";
          };
        };

        username = {
          show_always = true;
          style_user = "bg:surface0 fg:text";
          style_root = "bg:surface0 fg:text";
          format = "[ $user ]($style)";
        };

        directory = {
          style = "fg:mantle bg:peach";
          format = "[ $path ]($style)";
          truncation_length = 3;
          truncation_symbol = "…/";

          substitutions = {
            "Documents" = "󰈙 ";
            "Downloads" = " ";
            "Music" = "󰝚 ";
            "Pictures" = " ";
            "Developer" = "󰲋 ";
          };
        };

        git_branch = {
          symbol = "";
          style = "bg:teal";
          format = "[[ $symbol $branch ](fg:base bg:green)]($style)";
        };

        git_status = {
          style = "bg:teal";
          format = "[[($all_status$ahead_behind )](fg:base bg:green)]($style)";
        };

        nodejs = {
          symbol = "";
          style = "bg:teal";
          format = "[[ $symbol( $version) ](fg:base bg:teal)]($style)";
        };

        c = {
          symbol = " ";
          style = "bg:teal";
          format = "[[ $symbol( $version) ](fg:base bg:teal)]($style)";
        };

        rust = {
          symbol = "";
          style = "bg:teal";
          format = "[[ $symbol( $version) ](fg:base bg:teal)]($style)";
        };

        golang = {
          symbol = "";
          style = "bg:teal";
          format = "[[ $symbol( $version) ](fg:base bg:teal)]($style)";
        };

        php = {
          symbol = "";
          style = "bg:teal";
          format = "[[ $symbol( $version) ](fg:base bg:teal)]($style)";
        };

        java = {
          symbol = " ";
          style = "bg:teal";
          format = "[[ $symbol( $version) ](fg:base bg:teal)]($style)";
        };

        kotlin = {
          symbol = "";
          style = "bg:teal";
          format = "[[ $symbol( $version) ](fg:base bg:teal)]($style)";
        };

        haskell = {
          symbol = "";
          style = "bg:teal";
          format = "[[ $symbol( $version) ](fg:base bg:teal)]($style)";
        };

        python = {
          symbol = "";
          style = "bg:teal";
          format = "[[ $symbol( $version) ](fg:base bg:teal)]($style)";
        };

        docker_context = {
          symbol = "";
          style = "bg:mantle";
          format = "[[ $symbol( $context) ](fg:#83a598 bg:color_bg3)]($style)";
        };

        time = {
          disabled = false;
          time_format = "%R";
          style = "bg:peach";
          format = "[[  $time ](fg:mantle bg:purple)]($style)";
        };

        line_break.disabled = false;

        character = {
          disabled = false;
          success_symbol = "[](bold fg:green)";
          error_symbol = "[](bold fg:red)";
          vimcmd_symbol = "[](bold fg:creen)";
          vimcmd_replace_one_symbol = "[](bold fg:purple)";
          vimcmd_replace_symbol = "[](bold fg:purple)";
          vimcmd_visual_symbol = "[](bold fg:lavender)";
        };
      };
    };

    ##Spicitify
    spicetify = {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        playlistIcons
        historyShortcut
        adblock
        hidePodcasts
        shuffle
        fullAppDisplay
        volumePercentage
        history
      ];

      enabledCustomApps = with spicePkgs.apps; [
        newReleases
        lyricsPlus
        ncsVisualizer
      ];

    };

    #hyprlock
    hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 0; # Disable unlocking on mouse movement
        #grace = 10;
        hide_cursor = true;
        no_fade_in = false;
      };

      background = [
        {
          path = "/etc/nixos/wallpaper.jpg";
          blur_passes = 3;
          blur_size = 8;
          # monitor =
          #path = $XDG_CONFIG_HOME/hypr/scripts/current_wal;   # only png supported for now
          # color = $color0;

        }
      ];

      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(CFE6F4)";
          inner_color = "rgb(657DC2)";
          outer_color = "rgb(0D0E15)";
          outline_thickness = 5;
          placeholder_text = "Password...";
          shadow_passes = 2;
        }
      ];
    };
  };





#Fish
    fish = {
      enable = true;

      interactiveShellInit = ''
        set -g fish_greeting # Disable greeting

        # Add any custom initialization commands here
          nitch
      '';

      shellAliases = {
        # Add your aliases here
        ncg = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
        v = "nvim";
        sv = "sudo nvim";
        cat = "bat";
        ls = "eza --icons";
        ll = "eza -lh --icons --grid --group-directories-first";
        la = "eza -lah --icons --grid --group-directories-first";
        ".." = "cd ..";
        btop = "btop --utf-force";
        pipes = "pipes-rs";
      };

      shellInit = ''
        # Add environment variables or path modifications here
        fish_add_path $HOME/.local/bin
      '';

      plugins = [
        # Add fish plugins here if needed
        {
          name = "foreign-env";
          src = pkgs.fetchFromGitHub {
            owner = "oh-my-fish";
            repo = "plugin-foreign-env";
            rev = "dddd9213272a0ab848d474d0cbde12ad034e65bc";
            sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
          };
        }
      ];
    };

    #Cava
    cava = {
      enable = true;
      settings = {
        general = {
          framerate = 60;

        };

        color = {
          gradient = 1;
          gradient_count = 8;
          gradient_color_1 = "'#94e2d5'";
          gradient_color_2 = "'#89dceb'";
          gradient_color_3 = "'#74c7ec'";
          gradient_color_4 = "'#89b4fa'";
          gradient_color_5 = "'#cba6f7'";
          gradient_color_6 = "'#f5c2e7'";
          gradient_color_7 = "'#eba0ac'";
          gradient_color_8 = "'#f38ba8'";

        };

        #smoothing = {
        # noise_reduction = 1;
        #  monstercat = 0;
        #  waves = 1;
        #  gravity = 0;
        # };

      };
    };

    # # Rofi configuration
    # rofi = {
    #   enable = true;
    #   package = pkgs.rofi-wayland;
    #   font = "JetBrains Mono Nerd Font 12";
    #   # terminal = "${pkgs.alacritty}/bin/alacritty";
    #   terminal = "${pkgs.kitty}/bin/kitty";
    #   extraConfig = {
    #     modi = "drun,run,filebrowser,window";
    #     icon-theme = "Papirus";
    #     show-icons = true;
    #     drun-display-format = "{icon} {name}";
    #     #drun-display-format = "{name}";
    #     location = 0;
    #     disable-history = false;
    #     hide-scrollbar = true;

    #     sidebar-mode = true;
    #     border-radius = 10;

    #     #display-drun = " Apps ";
    #     display-drun = " Apps";
    #     display-run = " Run";
    #     display-filebrowser = " Files";
    #     display-window = " Windows";
    #     window-format = "{w} · {c} · {t}";

    #   };
    #   theme =
    #     let
    #       inherit (config.lib.formats.rasi) mkLiteral;
    #       import = [
    #         "~/.cache/wal/colors-rofi.rasi"
    #       ];
    #     in
    #     {

    #       "*" = {
    #         bg-col = mkLiteral "#24273a";
    #         bg-col-light = mkLiteral "#24273a";
    #         border-col = mkLiteral "#24273a";
    #         selected-col = mkLiteral "#24273a";
    #         blue = mkLiteral "#8aadf4";
    #         fg-col = mkLiteral "#cad3f5";
    #         fg-col2 = mkLiteral "#ed8796";
    #         grey = mkLiteral "#6e738d";
    #         teal = mkLiteral "#8bd5ca";

            

    #         width = mkLiteral "600";
    #         border-radius = mkLiteral "15px";
    #       };

    #       "element-text, element-icon, mode-switcher" = {
    #         background-color = mkLiteral "inherit";
    #         text-color = mkLiteral "inherit";
    #       };
    #       "window" = {
    #         height = mkLiteral "360px";
    #         border = mkLiteral "2px";
    #         border-color = mkLiteral "@teal";
    #         background-color = mkLiteral "@bg-col";
    #       };
    #       "mainbox" = {
    #         background-color = mkLiteral "@bg-col";
    #       };
    #       "inputbar" = {
    #         children = map mkLiteral [
    #           "prompt"
    #           "entry"
    #         ];
    #         background-color = mkLiteral "@bg-col";
    #         border-radius = mkLiteral "5px";
    #         padding = mkLiteral "2px";
    #       };
    #       "prompt" = {
    #         background-color = mkLiteral "@blue";
    #         padding = mkLiteral "6px";
    #         text-color = mkLiteral "@bg-col";
    #         border-radius = mkLiteral "3px";
    #         margin = mkLiteral "20px 0px 0px 20px";
    #       };
    #       "entry" = {
    #         padding = mkLiteral "6px";
    #         margin = mkLiteral "20px 0px 0px 10px";
    #         text-color = mkLiteral "@fg-col";
    #         background-color = mkLiteral "@bg-col";
    #       };
    #       "listview" = {
    #         border = mkLiteral "0px 0px 0px";
    #         padding = mkLiteral "6px 0px 0px";
    #         margin = mkLiteral "10px 0px 0px 20px";
    #         columns = mkLiteral "2";
    #         lines = mkLiteral "5";
    #         background-color = mkLiteral "@bg-col";
    #       };
    #       "element" = {
    #         padding = mkLiteral "5px";
    #         background-color = mkLiteral "@bg-col";
    #         text-color = mkLiteral "@fg-col";
    #       };
    #       "element-icon" = {
    #         size = mkLiteral "25px";
    #       };
    #       "element selected" = {
    #         background-color = mkLiteral "@selected-col";
    #         text-color = mkLiteral "@teal";
    #       };
    #       "button" = {
    #         padding = mkLiteral "10px";
    #         background-color = mkLiteral "@bg-col-light";
    #         text-color = mkLiteral "@grey";
    #         vertical-align = mkLiteral "0.5";
    #         horizontal-align = mkLiteral "0.5";
    #       };
    #       "button selected" = {
    #         background-color = mkLiteral "@bg-col";
    #         text-color = mkLiteral "@blue";
    #       };
    #       "message" = {
    #         background-color = mkLiteral "@bg-col-light";
    #         margin = mkLiteral "2px";
    #         padding = mkLiteral "2px";
    #         border-radius = mkLiteral "5px";
    #       };
    #       "textbox" = {
    #         padding = mkLiteral "6px";
    #         margin = mkLiteral "20px 0px 0px 20px";
    #         text-color = mkLiteral "@blue";
    #         background-color = mkLiteral "@bg-col-light";
    #       };
    #     };
    
    
    
     };

   




   # Rofi configuration
 xdg.configFile."rofi/config.rasi".text = ''
          @import "~/.config/rofi/pywal.rasi"

configuration {
  modi: "window,drun,ssh,combi,filebrowser,recursivebrowser";
  display-drun: "  ";
  icon-theme: "Papirus";
  show-icons: true;
  drun-display-format: "{icon} {name}";
  font: "Roboto Mono Nerd 12";
  combi-modi: "window,drun,ssh";
  terminal: "kitty";
  run-shell-command: "{terminal} -e {cmd}";
  sidebar-mode: true;
}
      '';
   


xdg.configFile."rofi/pywal.rasi".text  =  ''
       @import "~/.cache/wal/colors-rofi"
*{
  background-color: rgba(0, 0, 0, 0.41);
}

window{
	width: env(WIDTH, 35%);
	height: env(HEIGHT, 65%);
  	border: 2px;
	border-color: @active-background;
	border-radius: 15px;
}

element-icon{
  border-radius: 10px;
}

textbox{
	padding: 2em;
}

inputbar{
	padding: 0.82em;
}

mainbox{
  	background-position: center;
  	border-radius: 15px     ;	
}

entry {
  placeholder: "Type anything";
  cursor: pointer;
 }

listview{
    border: 0px 0px 0px;
}

element {
  orientation: horizontal ;
  spacing: 15px;
  border-radius: 15px;
  padding: 0.45em;
}

element-icon {
  size: 2em;
}
      '';
    

  # Hyprland configuration
  wayland.windowManager.hyprland = {
    enable = true;

      #  plugins = [
    # Format these which are build from source
    # inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars

    #To import prebuilt plugins
    #pkgs.hyprlandPlugins.<plugin name>
      #  pkgs.hyprlandPlugins.hyprtrails
      #  pkgs.hyprlandPlugins.hyprbars

      #  ];

    settings = {

      #      plugin = {
      #               hyprtrails = {
      #                       color = "rgba(ffaa00ff)";
      #                            };
      #                };
      "$mainMod" = "SUPER";
      # "$terminal" = "alacritty";
      "$terminal" = "kitty";
      "$menu" = "rofi";
      "$fileManager" = "nautilus";

      monitor = [
        "eDP-1,1920x1080@120.00,0x0,1"
        "HDMI-A-1,1920x1080@180.00,1920x0,1"
        # ",preferred,auto,1"
      ];

#############
### INPUT ###
#############
             input = {
      #   kb_layout = us;
      #   kb_variant = "";
      #   kb_model = "";
      #   kb_options = "";
      #   kb_rules = "";
      #   repeat_rate = 50;
      #   repeat_delay = 300;

      #   sensitivity = 0; #mouse sensitivity
      numlock_by_default = true;
      #   left_handed = false;
      #   follow_mouse = true;
      #   float_switch_override_focus = false;

      #   touchpad {
      #     disable_while_typing = true;
      #     natural_scroll = false;
      #     clickfinger_behavior = fals;e
      #     middle_button_emulation = true;
      #     tap-to-click = true;
      #     drag_lock = false;
      #           }

      #   # below for devices with touchdevice ie. touchscreen
      # 	# touchdevice {
      # 	# 	enabled = true;
      # 	# }

      # 	# below is for table see link above for proper variables
      # 	# tablet {
      # 	# 	transform = 0;
      # 	# 	left_handed = 0;
      # 	# }
       };

      # gestures {
      #   workspace_swipe = true;
      #   workspace_swipe_fingers = 3;
      #   workspace_swipe_distance = 500;
      #   workspace_swipe_invert = true;
      #   workspace_swipe_min_speed_to_force = 30;
      #   workspace_swipe_cancel_ratio = 0.5;
      #   workspace_swipe_create_new = true;
      #   workspace_swipe_forever = true;
      #   #workspace_swipe_use_r = true #uncomment if wanted a forever create a new workspace with swipe right
      # }

      # #Could help when scaling and not pixelating
      # xwayland {
      #   enabled = true
      #   force_zero_scaling = true
      # }
      # # render section for Hyprland >= v0.42.0
      # render {
      #   explicit_sync = 2
      #   explicit_sync_kms = 2
      #   direct_scanout = false
      # }
      # cursor {
      #   sync_gsettings_theme = true
      #   no_hardware_cursors = 2
      #   enable_hyprcursor = true
      #   warp_on_change_workspace = 2
      #   no_warps = true
      # }

      exec-once = [
        "waybar"
        "waypaper --restore"
        "wal -R" # Restore previous wallpaper and colorscheme
        # "hyprctl plugin load ${pkgs.hyprland-plugins.hyprtrails}"
        "swaync"
        "nm-applet --indicator &"
        #bluetooth
        "blueman-applet &"
        #"overskride"
        "swayosd-server &"

        "swww init"
        "flameshot"
        "/usr/lib/polkit-kde-authentication-agent-1"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "systemctl --user import-environment XDG_SESSION_TYPE XDG_CURRENT_DESKTOP"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland"
        "systemctl --user start hyprpolkitagent"
        #"$UserScripts/RainbowBorders.sh &" # Rainbow borders
      ];


###################
### KEYBINDINGS ###
###################

      bind = [
        "$mainMod , Return, exec, $terminal"
        "$mainMod,       Q, killactive,"
        "$mainMod SHIFT, Q, exit,"
        "$mainMod,       E, exec, $fileManager"
        "$mainMod,       F, togglefloating,"
        # "$mainMod,       A, exec, $menu -show drun"
        "$mainMod,       A, exec, pkill rofi || rofi -show drun -replace -i"
        "$mainMod,       P, pseudo,"
        "$mainMod,       M, exec, missioncenter" # Open Mission Center
        "$mainMod,       W, exec, waypaper " # Open wallpaper selector
        "$mainMod SHIFT, W, exec,waypaper --random "
        "$mainMod SHIFT, B, exec,pkill waybar || waybar" # Waybar toggle
        "$mainMod,       D, exec, bash -c 'pkill -f nwg-dock-hyprland || nwg-dock-hyprland'" # Dock Toggle
        "$mainMod,       J, togglesplit,"
        "$mainMod,       R, exec, bemoji -cn"
        "$mainMod,       C, exec, code"
        "$mainMod,       V, exec, cliphist list | $menu -dmenu | cliphist decode | wl-copy"
        "$mainMod,       B, exec, firefox"
        #"$mainMod SHIFT, B, exec, pkill -SIGUSR1 waybar"
        "$mainMod,       L, exec, loginctl lock-session"
        "$mainMod,       P, exec, hyprpicker -an"
        "$mainMod,       N, exec, swaync-client -t"
        ", Print, exec, grimblast --notify --freeze copysave area"
        "$mainMod CTRL,  Q, exec, wlogout -p layer-shell"
        "$mainMod,       PRINT, exec, flameshot gui"
        # Moving focus
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        # Moving windows
        "$mainMod SHIFT, left,  swapwindow, l"
        "$mainMod SHIFT, right, swapwindow, r"
        "$mainMod SHIFT, up,    swapwindow, u"
        "$mainMod SHIFT, down,  swapwindow, d"

        # Resizeing windows                   X  Y
        "$mainMod CTRL, left,  resizeactive, -60 0"
        "$mainMod CTRL, right, resizeactive,  60 0"
        "$mainMod CTRL, up,    resizeactive,  0 -60"
        "$mainMod CTRL, down,  resizeactive,  0  60"

        # Switching to or opening workspaces
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Moving windows to workspaces
        "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
        "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
        "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
        "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
        "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
        "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
        "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
        "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
        "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
        "$mainMod SHIFT, 0, movetoworkspacesilent, 10"

        # Scratchpad
        "$mainMod,       S, togglespecialworkspace,  magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"

        #Swayosd
        ", Caps_Lock, exec, swayosd-client --caps-lock"
        ", Num_Lock, exec, swayosd-client --num-lock"
      ];

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      # Laptop multimedia keys for volume and LCD brightness
      bindel = [
        ",XF86AudioRaiseVolume,  exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume,  exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute,         exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute,      exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        "$mainMod, bracketright, exec, brightnessctl s 10%+"
        "$mainMod, bracketleft,  exec, brightnessctl s 10%-"
      ];

      

      # Audio playback
      bindl =
        [
          ", XF86AudioNext,  exec, playerctl next"
          ", XF86AudioPause, exec, playerctl play-pause"
          ", XF86AudioPlay,  exec, playerctl play-pause"
          ", XF86AudioPrev,  exec, playerctl previous"
          ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
          ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
          ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
          ", XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
          ", XF86MonBrightnessDown, exec, swayosd-client --brightness lower"
        ]
        ++ (builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = toString (i + 1);
            in
            [
              "$mainMod, ${ws}, workspace, ${ws}"
              "$mainMod SHIFT, ${ws}, movetoworkspace, ${ws}"
            ]
          ) 9
        ));

#####################
### LOOK AND FEEL ###
#####################

      general = {
        gaps_in = 2;
        gaps_out = 2;
        border_size = 0;
        "col.active_border" = "rgba(33ccffee)";
        "col.inactive_border" = "rgba(595959aa)";
        # "col.active_border" = "rgba(b4befeee)";
        # "col.inactive_border" = "rgba(7aa2f7ee) rgba(87aaf8ee) 45deg";
        allow_tearing = false;
        # layout = "master";
      };

      decoration = {
        rounding = 8;
        active_opacity = 1.0;
        inactive_opacity = 0.8;
        fullscreen_opacity = 1.0;

        dim_inactive = true;
        dim_strength = 0.1;
        dim_special = 0.8;

        blur = {
          enabled = true;
          size = 6;
          passes = 2;
          new_optimizations = true;
          ignore_opacity = true;
          xray = true;
          # blurls = waybar;
          vibrancy = 0.1696;
        };
        shadow = {
          enabled = true;
          range = 30;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };

      # animations = {
      #   enabled = true;
      #   bezier = [
      #     "pace,0.46, 1, 0.29, 0.99"
      #     "overshot,0.13,0.99,0.29,1.1"
      #     "md3_decel, 0.05, 0.7, 0.1, 1"
      #   ];
      #   animation = [
      #     "windowsIn,1,6,md3_decel,slide"
      #     "windowsOut,1,6,md3_decel,slide"
      #     "windowsMove,1,6,md3_decel,slide"
      #     "fade,1,10,md3_decel"
      #     "workspaces,1,9,md3_decel,slide"
      #     "workspaces, 1, 6, default"
      #     "specialWorkspace,1,8,md3_decel,slide"
      #     "border,1,10,md3_decel"
      #     #"borderangle, 1, 180, liner, loop" #used by rainbow borders and rotating colors
      #   ];
      # };


# general = {
#     gaps_in = 10;
#     gaps_out = 40;
#     border_size = 3;
#     "col.active_border" = "rgba(fab387ff) rgba(fab387ff) 45deg";
#     "col.inactive_border" = "rgba(00000000)";
#     resize_on_border = false;
#     allow_tearing = false;
#     # layout = dwindle;
# };

# decoration = {
#     rounding = 10;
#     active_opacity = 0.8;
#     inactive_opacity = 0.3;
#     shadow = {
#         enabled = true;
#         range = 25;
#         render_power = 1000;
#         color = "rgba(fab387ff)";
#         color_inactive = "rgba(00000000)";
#     };
#     blur = {
#         enabled = true;
#         size = 1;
#         passes = 5;

#         vibrancy = 0.1696;
#     };
# };
animations = {
    enabled = true;
        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
         "winIn, 0.1, 1.1, 0.1, 1.1"
         "winOut, 0.3, -0.3, 0, 1"
         "liner, 1, 1, 1, 1"
         "overshot, 0.05, 0.9, 0.1, 1.05"
         "smoothOut, 0.5, 0, 0.99, 0.99"
         "smoothIn, 0.5, -0.5, 0.68, 1.5"
         "easeOutQuint,0.23,1,0.32,1"
         "easeInOutCubic,0.65,0.05,0.36,1" 
         "linear,0,0,1,1"
         "almostLinear,0.5,0.5,0.75,1.0"
         "quick,0.15,0,0.1,1"
        ];
        animation = 
        ["windows, 1, 6, wind, slide"
         "windowsIn, 1, 5, winIn, slide"
         "windowsOut, 1, 3, smoothOut, slide"
         "windowsMove, 1, 5, wind, slide"
         "border, 1, 1, liner"
         "borderangle, 1, 180, liner, loop" 
         "fade, 1, 3, smoothOut"
         "workspaces, 1, 5, overshot"
         "workspacesIn, 1, 5, winIn, slide"
         "workspacesOut, 1, 5, winOut, slide"
         "layers, 1, 3.81, easeOutQuint" 
         "layersIn, 1, 4, easeOutQuint, popin 50%"
         "layersOut, 1, 3, easeOutQuint, slide"
        ];
};

# dwindle = {
#     pseudotile = true; 
#     preserve_split = true; 
# };

# master = {
#     new_status = master;
# };

misc = {
    force_default_wallpaper = -1;
    disable_hyprland_logo = false;
};



      #systemd.variables = [ "--all" ];
      #  extraConfig = ''
      # source = ~/.cache/wal/hyprland.conf

      #  '';

      # Assigning workspace to a certain monitor. Below are just examples
      # workspace = 1, monitor:eDP-1
      # workspace = 2, monitor:eDP-1
      # workspace = 3, monitor:eDP-1
      # workspace = 4, monitor:eDP-1
      # workspace = 5, monitor:DP-2
      # workspace = 6, monitor:DP-2
      # workspace = 7, monitor:DP-2
      # workspace = 8, monitor:DP-2

      windowrule = [
        # Window rules
        "tile,title:^(kitty)$"
        "float,title:^(fly_is_kitty)$"
        "tile,^(Spotify)$"
        "tile,^(wps)$"
        "float, ^(waypaper)$"
        "float, ^(missioncenter)$"

        #   # Window rules
        #   windowrulev2 = float,title:^(flameshot)
        #   windowrulev2 = move 0 0,title:^(flameshot)
        #   windowrulev2 = suppressevent fullscreen,title:^(flameshot)

        #   windowrule = float, ^(pavucontrol)$
        #   windowrule = float, ^(nm-connection-editor)$
        #   windowrule = float, ^(rofi)$
        #   windowrule = float, ^(waypaper)$
        #   windowrule = float, ^(missioncenter)$
      ];

      windowrulev2 = [
        "float,title:^(flameshot)"
        "move 0 0,title:^(flameshot)"
        "suppressevent fullscreen,title:^(flameshot)"
        "opacity ${opacity} ${opacity},class:^(com.mitchellh.ghostty)$"
        "opacity ${opacity} ${opacity},class:^(zen-alpha)$"
        "float,class:^(pavucontrol)$"
        "float,class:^(file_progress)$"
        "float,class:^(confirm)$"
        "float,class:^(dialog)$"
        "float,class:^(download)$"
        "float,class:^(notification)$"
        "float,class:^(error)$"
        "float,class:^(confirmreset)$"
        "float,title:^(Open File)$"
        "float,title:^(branchdialog)$"
        "float,title:^(Confirm to replace files)$"
        "float,title:^(File Operation Progress)$"
        "float,title:^(mpv)$"
        "opacity 1.0 1.0,class:^(wofi)$"
      ];

    };
  };



# #nwg-dock configuration
   xdg.configFile."nwg-dock-hyprland/style.css".text = ''
   /* importing waybar colors as i am using same colours here */
   @import url("../../.cache/wal/colors-waybar.css");
   window {
	/*  background: rgba(99, 100, 127, 0.9);*/
	background: rgba(54, 48, 70, 0.8);
	border-radius: 30px;
	border-style: solid;
	border-width: 6px;
	/*	border-width:0px; */
	border-color: ${custom.primary_accent};
}

#box {
/* Define attributes of the box surrounding icons here */
/*    background : rgba(33, 26, 38, 0.2); */
	padding: 8px;
	margin-left: 20px;
	margin-right: 20px;
	margin-bottom: 2px;
	margin-top: 3.5px;
	border-radius: 70px;
	border-bottom-right-radius: 0px;
	border-bottom-left-radius: 0px;
  animation: gradient_f 20s ease-in infinite;
  transition: all 0.5s cubic-bezier(.55, 0.0, .28, 1.682), box-shadow 0.7s ease-in-out, background-color 0.7s ease-in-out;
  
  
}

#active {
	/* This is to underline the button representing the currently active window */
	/*	border: solid 2px;*/
	border-radius: 10px;
	/*	border-color: ${custom.tertiary_accent};*/
	background: ${custom.secondary_accent};
	}

button, image {
	background: none;
	border-style: none;
	box-shadow: none;
	color: ${custom.primary_accent};
}

button {
	/* border: 1px solid ${custom.secondary_accent}; */
}

button {
	padding: 4px;
	margin-left: 4px;
	margin-right: 4px;
	color:${custom.tertiary_accent};
	font-size: 12px;
}


button:hover {
	border-radius: 8px;
  /* border-radius: 80px; */
	background-color: rgba(204, 208, 218,1);
	background-size: 20%;
  margin: 10px;
  box-shadow: 0 0 10px;
  animation: gradient_f 20s ease-in infinite;
  transition: all 0.5s cubic-bezier(.55, 0.0, .28, 1.682), box-shadow 0.7s ease-in-out, background-color 0.7s ease-in-out;
}


button:focus {
	box-shadow: none
}

/*
 button:focus {
        background-size: 50%;
    	border: 0px;
    }
*/


       
 '';

  # Wlogout configuration

#############
### older ###
#############
#  xdg.configFile."wlogout/layout".text = ''
# {
#     "label" : "lock",
#     "action" : "swaylock",
#     "text" : "Lock",
#     "keybind" : "l"
# }
# {
#     "label" : "logout",
#     "action" : "hyprctl dispatch exit 0",
#     "text" : "Logout",
#     "keybind" : "e"
# }
# {
#     "label" : "suspend",
#     "action" : "swaylock -f && systemctl suspend",
#     "text" : "Suspend",
#     "keybind" : "u"
# }
# {
#     "label" : "shutdown",
#     "action" : "systemctl poweroff",
#     "text" : "Shutdown",
#     "keybind" : "s"
# }
# {
#     "label" : "hibernate",
#     "action" : "systemctl hibernate",
#     "text" : "Hibernate",
#     "keybind" : "h"
# }
# {
#     "label" : "reboot",
#     "action" : "systemctl reboot",
#     "text" : "Reboot",
#     "keybind" : "r"
# }
# '';

# xdg.configFile."wlogout/style.css".text = ''
# @import url("../../.cache/wal/colors-wlogout.css");

# * {
#     background-image: none;
#     font-family: "JetBrainsMono Nerd Font";
# }

# window {
#     background-color: rgba(12, 12, 12, 0.9);
# }

# button {
#     color: @main-fg;
#     background-color: rgba(12, 12, 12, 0.4);
#     outline-style: none;
#     border: 2px solid @wb-hvr-bg;
#     border-radius: 20px;
#     background-repeat: no-repeat;
#     background-position: center;
#     background-size: 25%;
#     margin: 5px;
#     transition: all 0.3s cubic-bezier(.55, 0.0, .28, 1.682);
#     box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
# }

# button:focus {
#     background-color: @wb-act-bg;
#     border-color: @wb-hvr-bg;
#     background-size: 30%;
# }

# button:hover {
#     background-color: @wb-hvr-bg;
#     border-color: @main-bg;
#     background-size: 35%;
#     box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
# }

# #lock, #logout, #suspend, #shutdown, #hibernate, #reboot {
#     margin: 10px;
# }

# #lock {
#     background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"));
# }

# #logout {
#     background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"));
# }

# #suspend {
#     background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"));
# }

# #shutdown {
#     background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"));
# }

# #hibernate {
#     background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png"));
# }

# #reboot {
#     background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"));
# }
# '';


#############
### newer ###
#############

xdg.configFile."wlogout/layout".text = ''
{
    "label" : "lock",
    "action" : "hyprlock",
    "text" : "Lock",
    "keybind" : "l"
}
{
    "label" : "hibernate",
    "action" : "systemctl hibernate",
    "text" : "Hibernate",
    "keybind" : "h"
}
{
    "label" : "logout",
    "action" : "loginctl terminate-user $USER",
    "text" : "Logout",
    "keybind" : "e"
}
{
    "label" : "shutdown",
    "action" : "systemctl poweroff",
    "text" : "Shutdown",
    "keybind" : "s"
}
{
    "label" : "suspend",
    "action" : "systemctl suspend",
    "text" : "Suspend",
    "keybind" : "u"
}
{
    "label" : "reboot",
    "action" : "systemctl reboot",
    "text" : "Reboot",
    "keybind" : "r"
}
'';

xdg.configFile."wlogout/style.css".text = ''
/* Import pywal colors */
@import url("../../.cache/wal/colors-wlogout.css");

* {
    background-image: none;
    font-family: "JetBrainsMono Nerd Font";
}

window {
    background-color: rgba(0, 0, 0, 0.6);
    background-size: cover;
    font-size: 16pt;
    color: @main-fg;
}

button {
    color: @main-fg;
    background-color: @main-bg;
    border-style: solid;
    border-width: 2px;
    background-repeat: no-repeat;
    background-position: center;
    background-size: 25%;
    border-radius: 80px;
    margin: 5px;
    transition: all 0.3s cubic-bezier(.55, 0.0, .28, 1.682);
    border: 2px solid @wb-act-bg;
}

button:active {
    background-color: @wb-act-bg;
    color: @wb-act-fg;
    outline-style: none;
}

button:focus {
    background-size: 50%;
    border-color: @wb-hvr-bg;
}

button:hover {
    background-color: @wb-hvr-bg;
    color: @wb-hvr-fg;
    background-size: 50%;
    margin: 30px;
    border-radius: 80px;
    box-shadow: 0 0 30px @wb-hvr-bg;
}

button span {
    font-size: 1.2em;
}

#lock, #logout, #suspend, #hibernate, #shutdown, #reboot {
    margin: 10px;
    border-radius: 20px;
    background-size: 25%;
    transition: all 0.3s ease;
}

#lock {
    background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"));
}

#logout {
    background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"));
}

#suspend {
    background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"));
}

#hibernate {
    background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png"));
}

#shutdown {
    background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"));
}

#reboot {
    background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"));
}
'';

#############
### newer V ###
#############

# xdg.configFile."wlogout/layout".text = ''
# {
#     "label" : "lock",
#     "action" : "swaylock",
#     "text" : "Lock",
#     "keybind" : "l"
# }
# {
#     "label" : "logout",
#     "action" : "hyprctl dispatch exit 0",
#     "text" : "Logout",
#     "keybind" : "e"
# }
# {
#     "label" : "suspend",
#     "action" : "swaylock -f && systemctl suspend",
#     "text" : "Suspend",
#     "keybind" : "u"
# }
# {
#     "label" : "shutdown",
#     "action" : "systemctl poweroff",
#     "text" : "Shutdown",
#     "keybind" : "s"
# }
# {
#     "label" : "hibernate",
#     "action" : "systemctl hibernate",
#     "text" : "Hibernate",
#     "keybind" : "h"
# }
# {
#     "label" : "reboot",
#     "action" : "systemctl reboot",
#     "text" : "Reboot",
#     "keybind" : "r"
# }
# '';

# xdg.configFile."wlogout/style.css".text = ''
# @import url("../../.cache/wal/colors-wlogout.css");

# * {
#     background-image: none;
#     font-family: "JetBrainsMono Nerd Font";
# }

# window {
#     background-color: rgba(12, 12, 12, 0.9);
# }

# button {
#     color: @main-fg;
#     background-color: rgba(12, 12, 12, 0.4);
#     outline-style: none;
#     border: none;
#     border-width: 0px;
#     background-repeat: no-repeat;
#     background-position: center;
#     background-size: 20%;
#     border-radius: 0px;
#     box-shadow: none;
#     text-shadow: none;
#     animation: gradient_f 20s ease-in infinite;
# }

# button:focus {
#     background-color: @wb-act-bg;
#     background-size: 30%;
# }

# button:hover {
#     background-color: @wb-hvr-bg;
#     background-size: 40%;
#     border-radius: ${wlog.active_rad}px;
#     animation: gradient_f 20s ease-in infinite;
#     transition: all 0.3s cubic-bezier(.55,0.0,.28,1.682);
# }

# button:hover#lock {
#     border-radius: ${wlog.active_rad}px;
#     margin : ${wlog.hvr}px 0px ${wlog.hvr}px ${wlog.mgn}px;
# }

# button:hover#logout {
#     border-radius: ${wlog.active_rad}px;
#     margin : ${wlog.hvr}px 0px ${wlog.hvr}px 0px;
# }

# button:hover#suspend {
#     border-radius: ${wlog.active_rad}px;
#     margin : ${wlog.hvr}px 0px ${wlog.hvr}px 0px;
# }

# button:hover#shutdown {
#     border-radius: ${wlog.active_rad}px;
#     margin : ${wlog.hvr}px 0px ${wlog.hvr}px 0px;
# }

# button:hover#hibernate {
#     border-radius: ${wlog.active_rad}px;
#     margin : ${wlog.hvr}px 0px ${wlog.hvr}px 0px;
# }

# button:hover#reboot {
#     border-radius: ${wlog.active_rad}px;
#     margin : ${wlog.hvr}px ${wlog.mgn}px ${wlog.hvr}px 0px;
# }


# #lock {
#     background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"));
#       border-radius: ${wlog.button_rad}px 0px 0px ${wlog.button_rad}px;
#     margin : ${wlog.mgn}px 0px ${wlog.mgn}px ${wlog.mgn}px;
# }

# #logout {
#     background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"));
#     border-radius: 0px 0px 0px 0px;
#     margin : ${wlog.mgn}px 0px ${wlog.mgn}px 0px;
# }

# #suspend {
#     background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"));
#     border-radius: 0px 0px 0px 0px;
#     margin : ${wlog.mgn}px 0px ${wlog.mgn}px 0px;
# }

# #shutdown {
#     background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"));
#     border-radius: 0px 0px 0px 0px;
#     margin : ${wlog.mgn}px 0px ${wlog.mgn}px 0px;

# }

# #hibernate {
#     background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png"));
#     border-radius: 0px 0px 0px 0px;
#     margin : ${wlog.mgn}px 0px ${wlog.mgn}px 0px;
# }

# #reboot {
#     background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"));
#     border-radius: 0px ${wlog.button_rad}px ${wlog.button_rad}px 0px;
#     margin : ${wlog.mgn}px ${wlog.mgn}px ${wlog.mgn}px 0px;
# }
# '';


####__________________________________________________________#######

  #Swayosd
  # Write the SwayOSD style configuration
  # xdg.configFile."swayosd/style.css".text = ''
  #   .osd {
  #     timeout: 2s;
  #     margin: 20px;
  #     padding: 20px;
  #     border-width: 2px;
  #     border-radius: 10px;
  #   }

  #   .bar {
  #     width: 200px;
  #     height: 20px;
  #     border-radius: 5px;
  #   }
  # '';

  

  #Fastfetch
  programs.fastfetch = {
    enable = true;

    settings = {
      display = {
        color = {
          keys = "35";
          output = "90";
        };
      };

      logo = {
        #source = ./nixos.png;
        type = "kitty-direct";
        height = 15;
        width = 30;
        padding = {
          top = 3;
          left = 3;
        };
      };

      modules = [
        "break"
        {
          type = "custom";
          format = "┌──────────────────────Hardware──────────────────────┐";
        }
        {
          type = "cpu";
          key = "│  ";
        }
        {
          type = "gpu";
          key = "│ 󰍛 ";
        }
        {
          type = "memory";
          key = "│ 󰑭 ";
        }
        {
          type = "custom";
          format = "└────────────────────────────────────────────────────┘";
        }
        "break"
        {
          type = "custom";
          format = "┌──────────────────────Software──────────────────────┐";
        }
        {
          type = "custom";
          format = " OS -> Nix-Os";
        }
        {
          type = "kernel";
          key = "│ ├ ";
        }
        {
          type = "packages";
          key = "│ ├󰏖 ";
        }
        {
          type = "shell";
          key = "└ └ ";
        }
        "break"
        {
          type = "wm";
          key = " WM";
        }
        {
          type = "wmtheme";
          key = "│ ├󰉼 ";
        }
        {
          type = "terminal";
          key = "└ └ ";
        }
        {
          type = "custom";
          format = "└────────────────────────────────────────────────────┘";
        }
        "break"
        {
          type = "custom";
          format = "┌────────────────────Uptime / Age────────────────────┐";
        }
        {
          type = "command";
          key = "│  ";
          text = # bash
            ''
              birth_install=$(stat -c %W /)
              current=$(date +%s)
              delta=$((current - birth_install))
              delta_days=$((delta / 86400))
              echo $delta_days days
            '';
        }
        {
          type = "uptime";
          key = "│  ";
        }
        {
          type = "custom";
          format = "└────────────────────────────────────────────────────┘";
        }
        "break"
      ];
    };
  };

  # Cursor configuration
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  # GTK configuration

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-GTK-Purple-Dark";
      package = pkgs.magnetic-catppuccin-gtk.override { accent = [ "purple" ]; };

    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders;

      # #Pywal
      # name = "wal";
      # package = pkgs.oomox;
    };

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';

    };

  };

  ##qt configuration
  #qt = {
  #        enable = true;
  #        platformTheme.name = "gtk";
  #        style.name = "gtk2";
  #    };

  # Allow unfree packages in home-manager
  nixpkgs.config.allowUnfree = true;

  # Enable fontconfig
  fonts.fontconfig.enable = true;
}
