{ pkgs, lib, config, ... }:

let
  cfg = config.programs.guifetch;

  guifetch = pkgs.flutter.buildFlutterApplication {
    pname = "guifetch";
    version = "0.0.3";
    src = ./.;  # Update this path to your actual source location
    pubspecLock = ./pubspec.lock;  # Add actual pubspec.lock file to your repo
    
    nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
    
    # Remove depsListFile and vendorHash
    flutterBuildFlags = [ "--release" ];
    
    postFixup = ''
      wrapProgram $out/bin/guifetch --suffix PATH : ${lib.makeBinPath [ pkgs.pciutils ]}
    '';
    
    meta = with lib; {
      description = "GUI system information tool";
      homepage = "https://github.com/yourusername/guifetch";
      license = licenses.mit;
      platforms = platforms.linux;
    };
  };

in {
  options.programs.guifetch = {
    enable = lib.mkEnableOption "guifetch";
    config = {
      backgroundColor = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Background color in ARGB format";
      };
      osId = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Override OS identifier";
      };
      osImage = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Custom OS image path";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ guifetch ];
    xdg.configFile."guifetch/guifetch.toml".text = lib.concatStringsSep "\n" (
      (lib.optional (cfg.config.backgroundColor != null) 
        "background_color = 0x${cfg.config.backgroundColor}") ++
      (lib.optional (cfg.config.osId != null)
        "os_id = ${cfg.config.osId}") ++
      (lib.optional (cfg.config.osImage != null)
        "os_image = ${cfg.config.osImage}")
    );
  };
}
