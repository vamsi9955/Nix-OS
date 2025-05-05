# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs,inputs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

#   # Bootloader.
#   boot.loader.systemd-boot.enable = false; #systemd enabled then grub doent work
#   boot.loader.efi.canTouchEfiVariables = true;

# ##Bootloader Theme
# boot.loader.grub.theme = pkgs.stdenv.mkDerivation {
#     pname = "distro-grub-themes";
#     version = "3.1";
#     src = pkgs.fetchFromGitHub {
#       owner = "AdisonCavani";
#       repo = "distro-grub-themes";
#       rev = "v3.1";
#       hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
#     };
#     installPhase = "cp -r customize/nixos $out";
#   };


  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    useOSProber = true;
    device = "nodev";
    theme = pkgs.stdenv.mkDerivation {
      pname = "distro-grub-themes";
      version = "3.1";
      src = pkgs.fetchFromGitHub {
        owner = "AdisonCavani";
        repo = "distro-grub-themes";
        rev = "v3.1";
        hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
      };
      installPhase = "cp -r customize/nixos $out";
    };
    extraConfig = ''
      insmod usb
      insmod xhci
      insmod usbkbd
      terminal_input usb_keyboard
    '';
  };




###Out of memory: Killed process .... during builds

  swapDevices = [
    {
      device = "/swapfile";
      size = 4096;
    }
  ];

  nix.settings = {
    max-jobs = 4;
    cores = 6;
    
  };






########
##Ntfs##
########

#Disadvantages of Each

#    ntfs3:
#        Cannot mount dirty volumes without using the "force" option, which risks data corruption.
#        May have compatibility issues with certain NTFS features or metadata created by Windows.
#        Still relatively new and may not be as thoroughly tested as ntfs-3g.
#    ntfs-3g:
#        Slower performance due to the overhead of operating in userspace via FUSE.
#        Higher CPU usage during large file operations.

#I have to use ntfs-3g as my external drive is marked as dirty and there seems to no stability and performance/speed issues with using this.
#Instead of doining it manually using command: "echo "blacklist ntfs3" | sudo tee /etc/modprobe.d/blacklist-ntfs3.conf"

#Add the following line to blacklist the ntfs3 module:
boot.blacklistedKernelModules = [ "ntfs3" ];



systemd = {
  user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
};




  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };


##Auto Cpu freq

##Failed assertions:
      # - You have set services.power-profiles-daemon.enable = true;
      # which conflicts with services.auto-cpufreq.enable = true;

#services.auto-cpufreq.enable = true;
 # Systemd services setup
#  systemd.packages = with pkgs; [
#    auto-cpufreq
#  ];


#SwayOSD
services.udev.packages = [ pkgs.swayosd ];

#Virtualization
virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true; #Only needed if you explicitly want QEMU to run as root. Otherwise, you can omit this.
        swtpm.enable = true; #Enables TPM emulation (useful for Windows 11).
        ovmf = {
          enable = true; #Enables UEFI support for VMs.
          packages = [
            (pkgs.OVMF.override {
              secureBoot = false;  # Set to true only if needed
              tpmSupport = true;
            }).fd
          ];
        };
      };
    };

    spiceUSBRedirection.enable = true; #Enables USB redirection in Spice for better device passthrough.
    podman.enable = true; #Enables Podman for container management. Fine if you need it, but unrelated to QEMU.
    # waydroid.enable = true;  # If you want Waydroid (Android in Linux Containers), make sure GPU passthrough works properly.
  };

 virtualisation.docker.enable = true;

#Bluetooth
hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;
  services.blueman.enable = true;

# Extra Logitech Support
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;

 # Enable MAC Randomize
#  systemd.services.macchanger = {
#    enable = true;
#    description = "Change MAC address";
#    wantedBy = [ "multi-user.target" ];
#    after = [ "network.target" ];
#    serviceConfig = {
#      Type = "oneshot";
#      ExecStart = "${pkgs.macchanger}/bin/macchanger -r wlp0s20f3";
#      ExecStop = "${pkgs.macchanger}/bin/macchanger -p wlp0s20f3";
#      RemainAfterExit = true;
#    };
#  };


#For waybar
nixpkgs.overlays = [
  (self: super: {
    waybar = super.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    });
  })
];

#DB errors "command-not-found"
programs.command-not-found.enable = false;

#NvidiaConfig
  # Enable OpenGL
  #hardware.opengl = {
    #enable = true;              ##depriciated
   # driSupport = true;
   # driSupport32Bit = true;
  #};

  hardware.graphics.enable = true;   ##use this

# Load nvidia driver for Xorg and Wayland
services.xserver.videoDrivers = ["nvidia"];

 # Enable access to nvidia from containers (Docker, Podman)
  hardware.nvidia-container-toolkit.enable = true;


  nixpkgs.config = {
   nvidia.acceptLicense = true;
   allowUnfreePredicate = pkg:
   builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "cudatoolkit"
      
    ];
};




  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;
    open = false;

# Enable the Nvidia settings menu,
  	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

# Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.latest;


     };           



 
 
 # Hyprland and Wayland support
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    
    
    # If using flake
    # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Light Desktop Manager.
  #services.xserver.displayManager.lightdm.enable = false;


######## 
##Sddm##

#  Check for SDDM Theme and face in folowing file/directory/
#  [Theme]
# Current=sddm-astronaut-theme
# FacesDir=/run/current-system/sw/share/sddm/faces
# ThemeDir=/run/current-system/sw/share/sddm/themes
# can also use : "ls /run/current-system/sw/share/sddm/themes/" 
 
  #_____________________________________________________________________
  services.displayManager.defaultSession = "hyprland";
  services.displayManager.sddm = {
    enable = true; # Enable SDDM
    package = pkgs.kdePackages.sddm;
    extraPackages = with pkgs; [
      kdePackages.qtsvg
      kdePackages.qt5compat
      kdePackages.qtmultimedia
      kdePackages.qtvirtualkeyboard
    ];
    #wayland.enable = true;
    theme = "sddm-astronaut-theme"; # Specify your theme
    settings = {
      Theme = {
        CursorTheme = "Bibata-Modern-Ice"; # Set custom cursor theme
      };
    };
  };
#_______________________________________________________________________-
#  services.xserver.displayManager.sddm = {
#     enable = true;
#     theme = "sddm-astronaut-theme";
#     package = pkgs.kdePackages.sddm;
#     #wayland.enable = true;
#   };

#      services.xserver.displayManager.sddm.extraPackages = with pkgs.kdePackages; [
#         qt5compat
#         qtsvg
#      ];
  


 services.xserver.desktopManager.cinnamon.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
 services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true; # Optional for professional audio tools

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };




  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vamsi = {
    isNormalUser = true;
    description = "vamsi";
    extraGroups = [ "networkmanager" "wheel" ];


    packages = with pkgs; [
    #  thunderbird
    #(opera.override { proprietaryCodecs = true; })
    steam
    neofetch
    lolcat
    
    
    ];
  };

  #Enable Fish
   programs.fish.enable = true;
   users.users.vamsi = {
     shell = pkgs.fish;
        };


#enable steam
programs.steam = {
  enable = true;
  remotePlay.openFirewall = true;
  dedicatedServer.openFirewall = true;
};
  # Install firefox.
  programs.firefox.enable = true;
  programs.firefox.nativeMessagingHosts.packages = with pkgs; [ uget-integrator ]; 

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

# Enable flakes support
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget


environment.systemPackages = with pkgs;  
[
 
    kdePackages.qtsvg
    kdePackages.qtmultimedia
    kdePackages.qtvirtualkeyboard
    kdePackages.qt5compat
    (pkgs.callPackage ./sddm.nix {
      theme = "cyberpunk"; # Set custom SDDM theme
    })



  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    libevdev
    gnome-text-editor
    overskride #bluetooth client
    #waybar
    #rofi-wayland
    swww # wallpaper
    #dunst # notification daemon
    libnotify
    wl-clipboard
    wlr-randr
    #wofi
    waypaper
    hyprpaper
    pipewire
    easyeffects # For advanced audio processing
    linux-wifi-hotspot
    qt6.qtwayland
    macchanger #mac address changer
    xdg-desktop-portal-hyprland
    #hyprpolkitagent
    polkit
    polkit_gnome
    hyprcursor
    bibata-cursors
    #rose-pine-hyprcursor  
    xdg-desktop-portal-gtk  # For Cinnamon
    sddm-astronaut
    #adi1090x-plymouth-themes
    #sleek-grub-theme
    ntfs3g
    swayosd
    google-chrome
    wf-recorder
    libreoffice-fresh
    cudaPackages.cudatoolkit  # Automatically resolves to the latest version
    virt-manager   # Virt-Manager GUI
    #gnome-boxes 
  ];
  
  # Enable XDG Portal
  xdg.portal = {
  enable = true;
  extraPortals = [ 
    #pkgs.xdg-desktop-portal-hyprland
    pkgs.xdg-desktop-portal-gtk
  ];
  wlr = {
    enable = true;
  };
};






# Environment variables for Wayland support
  environment.variables = {
    MOZ_ENABLE_WAYLAND = "1";       # Firefox Wayland support
    QT_QPA_PLATFORM = "wayland";   # Qt apps on Wayland
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland"; 
    _JAVA_AWT_WM_NONREPARENTING = "1"; # Java apps on Wayland
  };

fonts = {
  packages = with pkgs; [
    
    noto-fonts
    font-awesome
      

    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    fira-code
    fira-code-symbols
  ];
  fontconfig = {
    defaultFonts = {
      monospace = ["Noto Mono"  "JetBrainsMono Nerd Font" "FiraCode Nerd Font" ];
      sansSerif = ["Astronaut" "Noto Sans" "JetBrainsMono Nerd Font" ];
      serif = [ "JetBrainsMono Nerd Font" ];
    };
  };
};

# Qt theming (IMPORTANT for proper styling)
  # qt = {
  #   enable = true;
  #   platformTheme = "kde";
  #   style = "breeze";
  # };


##Optimization
nix.settings.auto-optimise-store = true;
nix.optimise.automatic = true;

#Garbage collector  
nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

 # System Auto Upgrade 

# Scheduled auto upgrade system (this is only for system upgrades, 
  # if you want to upgrade cargo\npm\pip global packages, docker containers or different part of the system 
  # or get really full system upgrade, use `topgrade` CLI utility manually instead.
  # I recommend running `topgrade` once a week or at least once a month)
  system.autoUpgrade = {
    enable = true;
    operation = "switch"; # If you don't want to apply updates immediately, only after rebooting, use `boot` option in this case
    flake = "/etc/nixos";
    flags = [ "--update-input" "nixpkgs" "--update-input" "rust-overlay" "--commit-lock-file" ];
    dates = "weekly";
    # channel = "https://nixos.org/channels/nixos-unstable";
  };

#SVG support for cursor
programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];

##Some Scecurity Stuff #---------------------------
 # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable Security Services
  # users.users.root.hashedPassword = "!";
  # security.tpm2 = {
  #   enable = true;
  #   pkcs11.enable = true;
  #   tctiEnvironment.enable = true;
  # };
  # security.apparmor = {
  #   enable = true;
  #   packages = with pkgs; [
  #     apparmor-utils
  #     apparmor-profiles
  #   ];
  # };
  # services.fail2ban.enable = true;
   security.pam.services.hyprlock = {};
   security.polkit.enable = true;
  # programs.browserpass.enable = true;
  # services.clamav = {
  #   daemon.enable = true;
  #   fangfrisch.enable = true;
  #   fangfrisch.interval = "daily";
  #   updater.enable = true;
  #   updater.interval = "daily"; #man systemd.time
  #   updater.frequency = 12;
  # };
  # programs.firejail = {
  #   enable = true;
  #   wrappedBinaries = { 
  #     mpv = {
  #       executable = "${lib.getBin pkgs.mpv}/bin/mpv";
  #       profile = "${pkgs.firejail}/etc/firejail/mpv.profile";
  #     };
  #     imv = {
  #       executable = "${lib.getBin pkgs.imv}/bin/imv";
  #       profile = "${pkgs.firejail}/etc/firejail/imv.profile";
  #     };
  #     zathura = {
  #       executable = "${lib.getBin pkgs.zathura}/bin/zathura";
  #       profile = "${pkgs.firejail}/etc/firejail/zathura.profile";
  #     };
  #     discord = {
  #       executable = "${lib.getBin pkgs.discord}/bin/discord";
  #       profile = "${pkgs.firejail}/etc/firejail/discord.profile";
  #     };
  #     slack = {
  #       executable = "${lib.getBin pkgs.slack}/bin/slack";
  #       profile = "${pkgs.firejail}/etc/firejail/slack.profile";
  #     };
  #     telegram-desktop = {
  #       executable = "${lib.getBin pkgs.tdesktop}/bin/telegram-desktop";
  #       profile = "${pkgs.firejail}/etc/firejail/telegram-desktop.profile";
  #     };
  #     brave = {
  #       executable = "${lib.getBin pkgs.brave}/bin/brave";
  #       profile = "${pkgs.firejail}/etc/firejail/brave.profile";
  #     };
  #     qutebrowser = {
  #       executable = "${lib.getBin pkgs.qutebrowser}/bin/qutebrowser";
  #       profile = "${pkgs.firejail}/etc/firejail/qutebrowser.profile";
  #     };
  #     thunar = {
  #       executable = "${lib.getBin pkgs.xfce.thunar}/bin/thunar";
  #       profile = "${pkgs.firejail}/etc/firejail/thunar.profile";
  #     };
  #     vscodium = {
  #       executable = "${lib.getBin pkgs.vscodium}/bin/vscodium";
  #       profile = "${pkgs.firejail}/etc/firejail/vscodium.profile";
  #     };
  #   };
  # };

  # environment.systemPackages = with pkgs; [
  #   vulnix       #scan command: vulnix --system
  #   clamav       #scan command: sudo freshclam; clamscan [options] [file/directory/-]
  #   chkrootkit   #scan command: sudo chkrootkit

  #   # passphrase2pgp
  #   pass-wayland
  #   pass2csv
  #   passExtensions.pass-tomb
  #   passExtensions.pass-update
  #   passExtensions.pass-otp
  #   passExtensions.pass-import
  #   passExtensions.pass-audit
  #   tomb
  #   pwgen
  #   pwgen-secure
  # ];
  ######------------------------------------

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
