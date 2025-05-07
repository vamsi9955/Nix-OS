{
  description = "A very basic flake";

  inputs = {
  nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  home-manager = {

   url = "github:nix-community/home-manager";
   inputs.nixpkgs.follows = "nixpkgs";
  };
  # # Hyprland flake for Wayland window manager
  #   hyprland = {
  #     url = "github:hyprwm/Hyprland";
  #     inputs.nixpkgs.follows = "nixpkgs";
  #    }; 
   

   spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #  hyprpanel = {
    #   url = "github:Jas-SinghFSU/HyprPanel";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

ax-shell.url = "github:maotseantonio/AX-Shell";
 nur = {
        url = "github:nix-community/NUR";
        inputs.nixpkgs.follows = "nixpkgs";
     };

  # #Zen-Browser
     zen-browser.url = "github:0xc000022070/zen-browser-flake";
          
};

outputs = { self, nixpkgs, home-manager,spicetify-nix,zen-browser,nur,ax-shell, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        #hyprland.nixosModules.default
        home-manager.nixosModules.home-manager

      # Add NUR nixpkgs overlay
      nur.modules.nixos.default

        
        {
          home-manager = {
            useGlobalPkgs = false;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };
            users.vamsi = import ./home.nix;
            backupFileExtension = "backup";  # Add this line
          };
        }
     
          #   {
          #   nixpkgs.overlays = [
          #     #inputs.hyprpanel.overlay
          #     # nur.overlays.default
          #   ];
          # }

          

      ];
      
    };
  };
}

