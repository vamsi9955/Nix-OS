{ pkgs,stdenv, fetchFromGitHub, ... }:
#Use this to find out hash by directly runnning in terminal
# nix-build -E 'with import <nixpkgs> {}; fetchFromGitHub {                                           
    
#         owner = "vamsi9955"; 
#         repo = "rofi"; 
#         rev = "2e0efe5"; 
#         sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";    
#   }'

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
  

  # Optionally include the Rofi configuration

 #### Rofi configuration
  xdg.configFile."rofi/config.rasi".text = ''
              @import "~/.config/rofi/pywal.rasi"

    

    configuration {
    modi: "window,drun,run,ssh,combi,filebrowser";
    display-drun: " Apps";
    display-run: " Run";
    display-filebrowser: " Files";
    display-window: " Windows";
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


  xdg.configFile."rofi/pywal.rasi".text = ''
           @import "~/.cache/wal/colors-rofi"
    *{
      
      background-color: rgba(0, 0, 0, 0.16);
    }

    window{
    	width: env(WIDTH, 35%);
    	height: env(HEIGHT, 65%);
      	border: 4px;
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

}
