{ pkgs,stdenv, fetchFromGitHub, ... }:
#Use this to find out hash by directly runnning in terminal
# nix-build -E 'with import <nixpkgs> {}; fetchFromGitHub {                                           


let
  rofiStyle = pkgs.stdenv.mkDerivation rec {
    pname = "rofi-style";
    version = "V1";
    dontBuild = true;

    src = pkgs.fetchFromGitHub {
      owner = "vamsi9955";
      repo = "rofi";
      rev = "2e0efe5";
      sha256 = "sha256-TVZ7oTdgZ6d9JaGGa6kVkK7FMjNeuhVTPNj2d7zRWzM=";
    };

    # installPhase = ''
    #   mkdir -p $out/.config/rofi/
    #   cp -aR $src/* $out/.config/rofi/
    # '';
installPhase = ''
      mkdir -p $out
      cp -aR $src/* $out/
    '';
    
  };
in {
  home.packages = with pkgs; [
    rofiStyle
    rofi-wayland
  ];


home.activation.copyRofiConfig = ''
    if [ ! -d "$HOME/.config/rofi" ]; then
      echo "Creating ~/.config/rofi"
      mkdir -p "$HOME/.config/rofi"
    fi

  #   # Copy only if the file does not exist
  #   for file in ${rofiStyle}/*; do
  #     dest="$HOME/.config/rofi/$(basename "$file")"
  #     if [ ! -e "$dest" ]; then
  #       echo "Copying $file to $dest"
  #       cp -a "$file" "$dest"
  #     fi
  #   done

  
  # Copy only the contents of the "files/" directory
  for file in ${rofiStyle}/files/*; do
    dest="$HOME/.config/rofi/$(basename "$file")"
    if [ ! -e "$dest" ]; then
      echo "Copying $file to $dest"
      cp -a "$file" "$dest"
    fi
  done
'';

 
#___________________________________________________

  

 #### Rofi configuration
   xdg.configFile."rofi/config.rasi".text = ''
    configuration {
      modi: "window,drun,run,ssh,combi,filebrowser";
      display-drun: "  Apps";
      display-run: "  Run";
      display-filebrowser: "  Files";
      display-window: "  Windows";
      icon-theme: "Papirus";
      show-icons: true;
      drun-display-format: "{icon} {name}";
      font: "Roboto Mono Nerd 12";
      combi-modi: "window,drun,ssh";
      terminal: "kitty";
      run-shell-command: "{terminal} -e {cmd}";
      sidebar-mode: true;
    }
    
    
    @import "~/.cache/wal/colors-rofi.rasi"
    
    * {
      background-color: transparent;
      text-color: @foreground;
      spacing: 2;
    }
    
    window {
      width: 35%;
      height: 65%;
      border: 4px;
      border-color: @color2;
      border-radius: 15px;
      background-color: rgba(0, 0, 0, 0.7);
      padding: 2.5ch;
    }
    
    mainbox {
      border: 0;
      padding: 0;
      background-position: center;
      border-radius: 15px;
    }
    
    message {
      border: 2px 0px 0px;
      border-color: @color2;
      padding: 1px;
    }
    
    textbox {
      text-color: @foreground;
      padding: 2em;
    }
    
    inputbar {
      children: [ prompt, textbox-prompt-colon, entry, case-indicator ];
      padding: 0.82em;
    }
    
    textbox-prompt-colon {
      expand: false;
      str: ">";
      margin: 0px 0.3em 0em 0em;
      text-color: @foreground;
    }
    
    listview {
      fixed-height: 0;
      border: 0px 0px 0px;
      spacing: 2px;
      scrollbar: true;
      padding: 2px 0px 0px;
    }
    
    element {
      border: 0;
      orientation: horizontal;
      spacing: 15px;
      border-radius: 15px;
      padding: 0.45em;
    }
    
    element-text {
      background-color: transparent;
      text-color: inherit;
    }
    
    element-icon {
      size: 2em;
      border-radius: 10px;
      background-color: transparent;
    }
    
    element.normal.normal {
      background-color: transparent;
      text-color: @foreground;
    }
    
    element.normal.urgent {
      background-color: rgba(255, 0, 0, 0.5);
      text-color: @foreground;
    }
    
    element.normal.active {
      background-color: rgba(0, 255, 0, 0.3);
      text-color: @foreground;
    }
    
    element.selected.normal {
      background-color: @color2;
      text-color: @foreground;
    }
    
    element.selected.urgent {
      background-color: rgba(255, 0, 0, 0.7);
      text-color: @foreground;
    }
    
    element.selected.active {
      background-color: rgba(0, 255, 0, 0.7);
      text-color: @foreground;
    }
    
    element.alternate.normal {
      background-color: transparent;
      text-color: @foreground;
    }
    
    element.alternate.urgent {
      background-color: @color1;
      text-color: @foreground;
    }
    
    element.alternate.active {
      background-color: @color2;
      text-color: @foreground;
    }
    
    scrollbar {
      width: 4px;
      handle-width: 8px;
      padding: 0;
      border-radius: 100px;
    }
    
    sidebar {
      border-radius: 100px;
    }
    
    button {
      text-color: @foreground;
    }
    
    button.selected {
      background-color: @color2;
      text-color: @foreground;
    }
    
    entry {
      text-color: @foreground;
      placeholder: "Type anything";
      cursor: pointer;
    }
    
    prompt {
      text-color: @foreground;
    }
  '';


  xdg.configFile."rofi/pywal.rasi".text = ''
    /* Import color variables from pywal */
    @import "~/.cache/wal/colors-rofi.rasi"
    
    window {
      width: 35%;
      height: 65%;
      border: 4px;
      border-color: @color2;
      border-radius: 15px;
      background-color: @background;
      padding: 2.5ch;
    }

    mainbox {
      border: 0;
      padding: 0;
      background-position: center;
      border-radius: 15px;
    }

    textbox {
      text-color: @foreground;
      padding: 2em;
    }

    inputbar {
      children: [ prompt, textbox-prompt-colon, entry, case-indicator ];
      padding: 0.82em;
      spacing: 0;
      text-color: @foreground;
    }

    textbox-prompt-colon {
      expand: false;
      str: ">";
      margin: 0px 0.3em 0em 0em;
      text-color: @foreground;
    }

    listview {
      fixed-height: 0;
      border: 0px 0px 0px;
      spacing: 2px;
      scrollbar: true;
      padding: 2px 0px 0px;
    }

    element {
      border: 0;
      padding: 0.45em;
      orientation: horizontal;
      spacing: 15px;
      border-radius: 15px;
    }

    element-text, element-icon {
      background-color: transparent;
      text-color: inherit;
    }

    element-icon {
      border-radius: 10px;
      size: 2em;
    }

    element.normal.normal {
      background-color: transparent;
      text-color: @foreground;
    }

    element.selected.normal {
      background-color: @color2;
      text-color: @foreground;
    }

    entry {
      text-color: @foreground;
      placeholder: "Type anything";
      cursor: pointer;
    }

    prompt {
      text-color: @foreground;
    }
  '';
  
  #______________________________________________________________________
  xdg.configFile."rofi/selector.rasi".text = ''
    
// Config //
configuration {
    modi:                        "drun";
    show-icons:                  true;
    drun-display-format:         "{name}";
    font:                        "JetBrainsMono Nerd Font 10";
}


@theme "~/.config/rofi/pywal.rasi"


// Main //
window {
    enabled:                     true;
    fullscreen:                  false;
    transparency:                "real";
    cursor:                      "default";
    spacing:                     0em;
    padding:                     0em;
    border:                      4px;
    border-radius:               15px;
    border-color:                @color6;
    background-color:            @background;
}

 


mainbox {
    enabled:                     true;
    orientation:                 horizontal;
    children:                    [ "dummy", "frame", "dummy" ];
    background-color:            transparent;
}
frame {
    children:                    [ "listview" ];
    background-color:            transparent;
}


// Lists //
listview {
    enabled:                     true;
    spacing:                     4em;
    padding:                     4em;
    columns:                     10;
    lines:                       1;
    dynamic:                     false;
    fixed-height:                false;
    fixed-columns:               true;
    reverse:                     true;
    cursor:                      "default";
    background-color:            transparent;
    text-color:                  @foreground;
}
dummy {
    width:                       2em;
    expand:                      false;
    background-color:            transparent;
}


// Elements //
element {
    enabled:                     true;
    spacing:                     0em;
    padding:                     0em;
    cursor:                      pointer;
    background-color:            transparent;
    text-color:                  @foreground;
}
element selected.normal {
    background-color:            @color2;
    text-color:                  @foreground;
}
element-icon {
    cursor:                      inherit;
    size:                        10em;
    background-color:            transparent;
    text-color:                  inherit;
    expand:                      false;
}
element-text {
    vertical-align:              0.5;
    horizontal-align:            0.5;
    cursor:                      inherit;
    background-color:            transparent;
    text-color:                  inherit;
}

    
  '';



  #__________________________
# Ensure directories exist
  home.activation.createRofiDirectories = ''
    mkdir -p $HOME/.config/rofi/assets
    mkdir -p $HOME/.config/rofi/styles
    mkdir -p $HOME/.cache/wallpapers/generated
  '';
} 