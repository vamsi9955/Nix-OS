{
  config,
  lib,
  pkgs,
  ...
}:

{

programs = {
  ############
    ##hyprlock##
    ############
    ##Version - 1
    # hyprlock = {
    #   enable = true;
    #   settings = {
    #     general = {
    #       disable_loading_bar = true;
    #       grace = 0; # Disable unlocking on mouse movement
    #       #grace = 10;
    #       hide_cursor = true;
    #       no_fade_in = false;
    #     };

    #     background = [
    #       {
    #         path = "/etc/nixos/wallpaper.jpg";
    #         blur_passes = 3;
    #         blur_size = 8;
    #         # monitor =
    #         #path = $XDG_CONFIG_HOME/hypr/scripts/current_wal;   # only png supported for now
    #         # color = $color0;

    #       }
    #     ];

    #     input-field = [
    #       {
    #         size = "200, 50";
    #         position = "0, -80";
    #         dots_center = true;
    #         fade_on_empty = false;
    #         font_color = "rgb(CFE6F4)";
    #         inner_color = "rgb(657DC2)";
    #         outer_color = "rgb(0D0E15)";
    #         outline_thickness = 5;
    #         placeholder_text = "Password...";
    #         shadow_passes = 2;
    #       }
    #     ];
    #   };
    # };

    ##Version - 2  ##style - 3

    # hyprlock = {
    #   enable = true;
    #   settings = {
    #     background = [{
    #       monitor = "";
    #       path = "~/.config/hypr/hyprlock.png";
    #       blur_passes = 3;
    #       contrast = 0.8916;
    #       brightness = 0.8172;
    #       vibrancy = 0.1696;
    #       vibrancy_darkness = 0.0;
    #     }];

    #     general = {
    #       no_fade_in = false;
    #       grace = 0;
    #       disable_loading_bar = false;
    #     };

    #     image = [{
    #       monitor = "";
    #       path = "~/.config/hypr/face.png";
    #       border_size = 2;
    #       border_color = "rgba(255, 255, 255, 0)";
    #       size = 130;
    #       rounding = -1;
    #       rotate = 0;
    #       reload_time = -1;
    #       position = "0, 40";
    #       halign = "center";
    #       valign = "center";
    #     }];

    #     label = [
    #       {
    #         monitor = "";
    #         text = "cmd[update:1000] echo -e \"$(date +\"%A, %B %d\")\"";
    #         color = "rgba(216, 222, 233, 0.70)";
    #         font_size = 25;
    #         font_family = "SF Pro Display Bold";
    #         position = "0, 350";
    #         halign = "center";
    #         valign = "center";
    #       }
    #       {
    #         monitor = "";
    #         text = "cmd[update:1000] echo \"<span>$(date +\"%I:%M\")</span>\"";
    #         color = "rgba(216, 222, 233, 0.70)";
    #         font_size = 120;
    #         font_family = "SF Pro Display Bold";
    #         position = "0, 250";
    #         halign = "center";
    #         valign = "center";
    #       }
    #       {
    #         monitor = "";
    #         text = "$USER";
    #         color = "rgba(216, 222, 233, 0.80)";
    #         outline_thickness = 2;
    #         dots_size = 0.2;
    #         dots_spacing = 0.2;
    #         dots_center = true;
    #         font_size = 18;
    #         font_family = "SF Pro Display Bold";
    #         position = "0, -130";
    #         halign = "center";
    #         valign = "center";
    #       }
    #       {
    #         monitor = "";
    #         text = "cmd[update:1000] echo \"$(~/.config/hypr/Scripts/songdetail.sh)\"";
    #         color = "rgba(255, 255, 255, 0.6)";
    #         font_size = 18;
    #         font_family = "JetBrains Mono Nerd, SF Pro Display Bold";
    #         position = "0, 50";
    #         halign = "center";
    #         valign = "bottom";
    #       }
    #     ];

    #     shape = [{
    #       monitor = "";
    #       size = "300, 60";
    #       color = "rgba(255, 255, 255, .1)";
    #       rounding = -1;
    #       border_size = 0;
    #       border_color = "rgba(253, 198, 135, 0)";
    #       rotate = 0;
    #       xray = false;
    #       position = "0, -130";
    #       halign = "center";
    #       valign = "center";
    #     }];

    #     input-field = [{
    #       monitor = "";
    #       size = "300, 60";
    #       outline_thickness = 2;
    #       dots_size = 0.2;
    #       dots_spacing = 0.2;
    #       dots_center = true;
    #       outer_color = "rgba(0, 0, 0, 0)";
    #       inner_color = "rgba(255, 255, 255, 0.1)";
    #       font_color = "rgb(200, 200, 200)";
    #       fade_on_empty = false;
    #       font_family = "SF Pro Display Bold";
    #       placeholder_text = "<i><span foreground=\"##ffffff99\">🔒 Enter Pass</span></i>";
    #       hide_input = false;
    #       position = "0, -210";
    #       halign = "center";
    #       valign = "center";
    #     }];
    #   };
    # };

    ##Version - 3  ##Style-4

    # hyprlock = {
    #   enable = true;
    #   settings = {
    #     background = [{
    #       monitor = "";
    #       path = "~/.config/hypr/hyprlock.png";
    #       blur_passes = 0;
    #       contrast = 0.8916;
    #       brightness = 0.8916;
    #       vibrancy = 0.8916;
    #       vibrancy_darkness = 0.0;
    #     }];

    #     general = {
    #       no_fade_in = false;
    #       grace = 0;
    #       disable_loading_bar = false;
    #     };

    #     image = [{
    #       monitor = "";
    #       path = "~/.config/hypr/face.png";
    #       border_size = 2;
    #       border_color = "rgba(216, 222, 233, 0.80)";
    #       size = 100;
    #       rounding = -1;
    #       rotate = 0;
    #       reload_time = -1;
    #       position = "25, 200";
    #       halign = "center";
    #       valign = "center";
    #     }];

    #     label = [
    #       {
    #         monitor = "";
    #         text = "Vamsi";
    #         color = "rgba(216, 222, 233, 0.80)";
    #         outline_thickness = 0;
    #         dots_size = 0.2;
    #         dots_spacing = 0.2;
    #         dots_center = true;
    #         font_size = 20;
    #         font_family = "SF Pro Display Bold";
    #         position = "25, 110";
    #         halign = "center";
    #         valign = "center";
    #       }
    #       {
    #         monitor = "";
    #         text = "cmd[update:1000] echo \"<span>$(date +\"%I:%M\")</span>\"";
    #         color = "rgba(216, 222, 233, 0.80)";
    #         font_size = 60;
    #         font_family = "SF Pro Display Bold";
    #         position = "30, -8";
    #         halign = "center";
    #         valign = "center";
    #       }
    #       {
    #         monitor = "";
    #         text = "cmd[update:1000] echo -e \"$(date +\"%A, %B %d\")\"";
    #         color = "rgba(216, 222, 233, .80)";
    #         font_size = 19;
    #         font_family = "SF Pro Display Bold";
    #         position = "35, -60";
    #         halign = "center";
    #         valign = "center";
    #       }
    #       {
    #         monitor = "";
    #         text = "$USER";
    #         color = "rgba(216, 222, 233, 0.80)";
    #         outline_thickness = 0;
    #         dots_size = 0.2;
    #         dots_spacing = 0.2;
    #         dots_center = true;
    #         font_size = 16;
    #         font_family = "SF Pro Display Bold";
    #         position = "38, -190";
    #         halign = "center";
    #         valign = "center";
    #       }
    #     ];

    #     shape = [{
    #       monitor = "";
    #       size = "320, 55";
    #       color = "rgba(255, 255, 255, 0.1)";
    #       rounding = -1;
    #       border_size = 0;
    #       border_color = "rgba(255, 255, 255, 1)";
    #       rotate = 0;
    #       xray = false;
    #       position = "34, -190";
    #       halign = "center";
    #       valign = "center";
    #     }];

    #     input-field = [{
    #       monitor = "";
    #       size = "320, 55";
    #       outline_thickness = 0;
    #       dots_size = 0.2;
    #       dots_spacing = 0.2;
    #       dots_center = true;
    #       outer_color = "rgba(255, 255, 255, 0)";
    #       inner_color = "rgba(255, 255, 255, 0.1)";
    #       font_color = "rgb(200, 200, 200)";
    #       fade_on_empty = false;
    #       font_family = "SF Pro Display Bold";
    #       placeholder_text = "<i><span foreground=\"##ffffff99\">🔒  Enter Pass</span></i>";
    #       hide_input = false;
    #       position = "34, -268";
    #       halign = "center";
    #       valign = "center";
    #     }];
    #   };
    # };

    ##Version - 4  #Style - 7

    # hyprlock = {
    #   enable = true;
    #   settings = {
    #     background = [{
    #       monitor = "";
    #       path = "~/.config/hypr/hyprlock.png";
    #       blur_passes = 0;
    #       contrast = 0.8916;
    #       brightness = 0.8172;
    #       vibrancy = 0.1696;
    #       vibrancy_darkness = 0.0;
    #     }];

    #     general = {
    #       no_fade_in = false;
    #       grace = 0;
    #       disable_loading_bar = false;
    #     };

    #     label = [
    #       {
    #         monitor = "";
    #         text = "cmd[update:1000] echo \"<span>$(date +\"%I\")</span>\"";
    #         color = "rgba(255, 255, 255, 1)";
    #         font_size = 125;
    #         font_family = "StretchPro";
    #         position = "-80, 190";
    #         halign = "center";
    #         valign = "center";
    #       }
    #       {
    #         monitor = "";
    #         text = "cmd[update:1000] echo \"<span>$(date +\"%M\")</span>\"";
    #         color = "rgba(147, 196, 255, 1)";
    #         font_size = 125;
    #         font_family = "StretchPro";
    #         position = "0, 70";
    #         halign = "center";
    #         valign = "center";
    #       }
    #       {
    #         monitor = "";
    #         text = "cmd[update:1000] echo -e \"$(date +\"%d %B, %a.\")\"";
    #         color = "rgba(255, 255, 255, 100)";
    #         font_size = 22;
    #         font_family = "Suisse Int'l Mono";
    #         position = "20, -8";
    #         halign = "center";
    #         valign = "center";
    #       }
    #       {
    #         monitor = "";
    #         text = "$USER";
    #         color = "rgba(216, 222, 233, 0.80)";
    #         outline_thickness = 2;
    #         dots_size = 0.2;
    #         dots_spacing = 0.2;
    #         dots_center = true;
    #         font_size = 22;
    #         font_family = "SF Pro Display Bold";
    #         position = "0, -220";
    #         halign = "center";
    #         valign = "center";
    #       }
    #       {
    #         monitor = "";
    #         text = "cmd[update:1000] echo \"$(~/.config/hypr/Scripts/songdetail.sh)\"";
    #         color = "rgba(147, 196, 255, 1)";
    #         font_size = 18;
    #         font_family = "JetBrains Mono Nerd, SF Pro Display Bold";
    #         position = "0, 20";
    #         halign = "center";
    #         valign = "bottom";
    #       }
    #     ];

    #     input-field = [{
    #       monitor = "";
    #       size = "300, 60";
    #       outline_thickness = 2;
    #       dots_size = 0.2;
    #       dots_spacing = 0.2;
    #       dots_center = true;
    #       outer_color = "rgba(0, 0, 0, 0)";
    #       inner_color = "rgba(255, 255, 255, 0.1)";
    #       font_color = "rgb(200, 200, 200)";
    #       fade_on_empty = false;
    #       font_family = "SF Pro Display Bold";
    #       placeholder_text = "<i><span foreground=\"##ffffff99\">🔒 Enter Pass</span></i>";
    #       hide_input = false;
    #       position = "0, -290";
    #       halign = "center";
    #       valign = "center";
    #     }];
    #   };
    # };

    ##Version - 5  #Style - 9

    hyprlock = {
      enable = true;
      settings = {
        background = [
          {
            monitor = "";
            path = "~/.config/hypr/hyprlock.png";
            blur_passes = 2;
            blur_size = 2;
            contrast = 0.8916;
            brightness = 0.8172;
            vibrancy = 0.1696;
            vibrancy_darkness = 0.0;
          }
        ];

        general = {
          no_fade_in = false;
          grace = 0;
          disable_loading_bar = false;
        };

        input-field = [
          {
            monitor = "";
            size = "250, 60";
            outline_thickness = 2;
            dots_size = 0.2;
            dots_spacing = 0.2;
            dots_center = true;
            outer_color = "rgba(0, 0, 0, 0)";
            inner_color = "rgba(100, 114, 125, 0.4)";
            font_color = "rgb(200, 200, 200)";
            fade_on_empty = false;
            font_family = "SF Pro Display Bold";
            placeholder_text = "<i><span foreground=\"##ffffff99\">Enter Pass</span></i>";
            hide_input = false;
            position = "0, -225";
            halign = "center";
            valign = "center";
          }
        ];

        label = [
          {
            monitor = "";
            text = "cmd[update:1000] echo \"<span>$(date +\"%I:%M\")</span>\"";
            color = "rgba(216, 222, 233, 0.70)";
            font_size = 130;
            font_family = "SF Pro Display Bold";
            position = "0, 240";
            halign = "center";
            valign = "center";
          }
          {
            monitor = "";
            text = "cmd[update:1000] echo -e \"$(date +\"%A, %d %B\")\"";
            color = "rgba(216, 222, 233, 0.70)";
            font_size = 30;
            font_family = "SF Pro Display Bold";
            position = "0, 105";
            halign = "center";
            valign = "center";
          }
          {
            monitor = "";
            text = "Hi, $USER";
            color = "rgba(216, 222, 233, 0.70)";
            font_size = 25;
            font_family = "SF Pro Display Bold";
            position = "0, -130";
            halign = "center";
            valign = "center";
          }
          {
            monitor = "";
            # text = "cmd[update:1000] echo "$(~/.config/hypr/Scripts/songdetail.sh)"";
            text = ''cmd[update:1000] echo "$(~/.config/hypr/Scripts/songdetail.sh)"'';
            color = "rgba(255, 255, 255, 0.7)";
            font_size = 18;
            font_family = "JetBrains Mono Nerd, SF Pro Display Bold";
            position = "0, 60";
            halign = "center";
            valign = "bottom";
          }
        ];

        image = [
          {
            monitor = "";
            path = "~/.config/hypr/face.png";
            border_color = "0xffdddddd";
            border_size = 0;
            size = 120;
            rounding = -1;
            rotate = 0;
            reload_time = -1;
            position = "0, -20";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };

    ##Version - 6 #Style - 10

    # hyprlock = {
    #   enable = true;
    #   settings = {
    #     background = [{
    #       monitor = "";
    #       path = "~/.config/hypr/hyprlock.png";
    #       blur_passes = 2;
    #       contrast = 0.8916;
    #       brightness = 0.8172;
    #       vibrancy = 0.1696;
    #       vibrancy_darkness = 0.0;
    #     }];

    #     general = {
    #       no_fade_in = false;
    #       grace = 0;
    #       disable_loading_bar = false;
    #     };

    #     label = [
    #       {
    #         monitor = "";
    #         text = "cmd[update:1000] echo -e \"$(date +\"%A\")\"";
    #         color = "rgba(216, 222, 233, 0.70)";
    #         font_size = 90;
    #         font_family = "SF Pro Display Bold";
    #         position = "0, 350";
    #         halign = "center";
    #         valign = "center";
    #       }
    #       {
    #         monitor = "";
    #         text = "cmd[update:1000] echo -e \"$(date +\"%d %B\")\"";
    #         color = "rgba(216, 222, 233, 0.70)";
    #         font_size = 40;
    #         font_family = "SF Pro Display Bold";
    #         position = "0, 250";
    #         halign = "center";
    #         valign = "center";
    #       }
    #       {
    #         monitor = "";
    #         text = "cmd[update:1000] echo \"<span>$(date +\"- %I:%M -\")</span>\"";
    #         color = "rgba(216, 222, 233, 0.70)";
    #         font_size = 20;
    #         font_family = "SF Pro Display Bold";
    #         position = "0, 190";
    #         halign = "center";
    #         valign = "center";
    #       }
    #       {
    #         monitor = "";
    #         text = "$USER";
    #         color = "rgba(216, 222, 233, 0.80)";
    #         outline_thickness = 2;
    #         dots_size = 0.2;
    #         dots_spacing = 0.2;
    #         dots_center = true;
    #         font_size = 18;
    #         font_family = "SF Pro Display Bold";
    #         position = "0, -130";
    #         halign = "center";
    #         valign = "center";
    #       }
    #       {
    #         monitor = "";
    #         text = "󰐥  󰜉  󰤄";
    #         color = "rgba(255, 255, 255, 0.6)";
    #         font_size = 50;
    #         position = "0, 100";
    #         halign = "center";
    #         valign = "bottom";
    #       }
    #     ];

    #     image = [{
    #       monitor = "";
    #       path = "~/.config/hypr/face.png";
    #       border_size = 2;
    #       border_color = "rgba(255, 255, 255, .65)";
    #       size = 130;
    #       rounding = -1;
    #       rotate = 0;
    #       reload_time = -1;
    #       position = "0, 40";
    #       halign = "center";
    #       valign = "center";
    #     }];

    #     shape = [{
    #       monitor = "";
    #       size = "300, 60";
    #       color = "rgba(255, 255, 255, .1)";
    #       rounding = -1;
    #       border_size = 0;
    #       border_color = "rgba(255, 255, 255, 0)";
    #       rotate = 0;
    #       xray = false;
    #       position = "0, -130";
    #       halign = "center";
    #       valign = "center";
    #     }];

    #     input-field = [{
    #       monitor = "";
    #       size = "300, 60";
    #       outline_thickness = 2;
    #       dots_size = 0.2;
    #       dots_spacing = 0.2;
    #       dots_center = true;
    #       outer_color = "rgba(255, 255, 255, 0)";
    #       inner_color = "rgba(255, 255, 255, 0.1)";
    #       font_color = "rgb(200, 200, 200)";
    #       fade_on_empty = false;
    #       font_family = "SF Pro Display Bold";
    #       placeholder_text = "<i><span foreground=\"##ffffff99\">🔒 Enter Pass</span></i>";
    #       hide_input = false;
    #       position = "0, -210";
    #       halign = "center";
    #       valign = "center";
    #     }];
    #   };
    # };

};
}