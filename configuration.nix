# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs,inputs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

##Bootloader Theme
boot.loader.grub.theme = pkgs.stdenv.mkDerivation {
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
 
   # Configure the systemd service
  # systemd.services.swayosd-libinput-backend = {
  #   description = "SwayOSD LibInput backend for listening to keys";
  #   documentation = [ "https://github.com/ErikReider/SwayOSD" ];
  #   wantedBy = [ "graphical.target" ];
  #   partOf = [ "graphical.target" ];
  #   after = [ "graphical.target" ];
  #   serviceConfig = {
  #     Type = "dbus";
  #     BusName = "org.erikreider.swayosd";
  #     ExecStart = "${pkgs.swayosd}/bin/swayosd-libinput-backend";
  #     Restart = "on-failure";
  #     RestartSec = "1";
  #   };
  # };




#Bluetooth
hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;
  services.blueman.enable = true;

# Extra Logitech Support
  hardware.logitech.wireless.enable = false;
  hardware.logitech.wireless.enableGraphical = false;

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



#NvidiaConfig
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
   # driSupport = true;
   # driSupport32Bit = true;
  };

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

# Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    #Fine-grained power management requires offload to be enabled.
      # powerManagement.finegrained = true;

# Dynamic Boost. It is a technology found in NVIDIA Max-Q design laptops with RTX GPUs.
    # It intelligently and automatically shifts power between
    # the CPU and GPU in real-time based on the workload of your game or application.
   # dynamicBoost.enable = lib.mkForce true;

# Enable the Nvidia settings menu,
  	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

# Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.latest;

# Nvidia Optimus PRIME. It is a technology developed by Nvidia to optimize
    # the power consumption and performance of laptops equipped with their GPUs.
    # It seamlessly switches between the integrated graphics,
    # usually from Intel, for lightweight tasks to save power,
    # and the discrete Nvidia GPU for performance-intensive tasks.
#    prime = {
 # 		offload = {
  #			enable = true;
  #			enableOffloadCmd = true;
   #               };

                 # FIXME: Change the following values to the correct Bus ID values for your system!
      # More on "https://wiki.nixos.org/wiki/Nvidia#Configuring_Optimus_PRIME:_Bus_ID_Values_(Mandatory)"
  #		nvidiaBusId = "PCI:1:0:0";
  #		intelBusId = "PCI:0:2:0";
                #amdgpuBusId = "PCI:54:0:0"; # If you have an AMD iGPU



  #		};
     };           

# NixOS specialization named 'nvidia-sync'. Provides the ability
  # to switch the Nvidia Optimus Prime profile
  # to sync mode during the boot process, enhancing performance.

######
#When you create a specialisation, NixOS generates two separate boot options:

 #   A default configuration that boots into TTY
 #   A "nvidia-sync" configuration that boots into SDDM
#######
 # specialisation = {
 #   nvidia-sync.configuration = {
 #     system.nixos.tags = [ "nvidia-sync" ];
 #     hardware.nvidia = {
 #       powerManagement.finegrained = lib.mkForce false;

 #       prime.offload.enable = lib.mkForce false;
 #       prime.offload.enableOffloadCmd = lib.mkForce false;

 #       prime.sync.enable = lib.mkForce true;
 #     };
 #  };
 # };
###########------------------#############
  
  
   
 
#A trick for pywal walpaper for rebuidd switch but dosent seem to work
# system.activationScripts.waypaperConfig = ''
#   if [ -f ~/.config/waypaper/config.ini ]; then
#     sed -i '/^post_command/d' ~/.config/waypaper/config.ini
#     echo 'post_command = "theme-reload"' >> ~/.config/waypaper/config.ini
#   else
#     mkdir -p ~/.config/waypaper
#     echo '[Settings]' > ~/.config/waypaper/config.ini
#     echo 'post_command = "theme-reload"' >> ~/.config/waypaper/config.ini
#   fi
# '';


 
 
 # Hyprland and Wayland support
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Cinnamon Desktop Environment.
  services.xserver.displayManager.lightdm.enable = false;
  
 # services.xserver.displayManager.sddm.enable = true;
 
    services.xserver.displayManager.sddm = {
    enable = true;
    theme = "sddm-astronaut-theme";
    package = pkgs.kdePackages.sddm;
    #wayland.enable = true;
  };

     services.xserver.displayManager.sddm.extraPackages = with pkgs.kdePackages; [
        qt5compat
        qtsvg
     ];


 services.xserver.desktopManager.cinnamon.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

# Enable flakes support
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    libevdev
    gnome-text-editor
    overskride #bluetooth client
    #waybar
    #rofi-wayland
    #swww # wallpaper
    #dunst # notification daemon
    #libnotify
    #wl-clipboard
    wlr-randr
    #wofi
    qt6.qtwayland
    macchanger #mac address changer
    xdg-desktop-portal-hyprland  
    xdg-desktop-portal-gtk  # For Cinnamon
    sddm-astronaut
    swayosd
    google-chrome
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
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    fira-code
    fira-code-symbols
  ];
  fontconfig = {
    defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" "FiraCode Nerd Font" ];
      sansSerif = [ "JetBrainsMono Nerd Font" ];
      serif = [ "JetBrainsMono Nerd Font" ];
    };
  };
};

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
  # # security.polkit.enable = true;
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
