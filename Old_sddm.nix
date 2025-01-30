{ stdenv, fetchFromGitHub, fetchzip, lib, qtbase, qtsvg,qtvirtualkeyboard, qtmultimedia, qtgraphicaleffects, qtquickcontrols2, wrapQtAppsHook }:

{
  sddm-sugar-dark = stdenv.mkDerivation rec {
    pname = "sddm-sugar-dark-theme";
    version = "1.2";
    dontBuild = true;

    src = fetchFromGitHub {
      owner = "MarianArlt";
      repo = "sddm-sugar-dark";
      rev = "v${version}";
      sha256 = "0gx0am7vq1ywaw2rm1p015x90b75ccqxnb1sz3wy8yjl27v82yhb";
    };

    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/sugar-dark
    '';
  };

  tokyo-night = stdenv.mkDerivation rec {
    pname = "tokyo-night-sddm";
    version = "1.0";
    dontBuild = true;

    src = fetchFromGitHub {
      owner = "rototrash";
      repo = "tokyo-night-sddm";
      rev = "320c8e74ade1e94f640708eee0b9a75a395697c6";
      sha256 = "sha256-JRVVzyefqR2L3UrEK2iWyhUKfPMUNUnfRZmwdz05wL0=";
    };

    nativeBuildInputs = [ wrapQtAppsHook ];

    propagatedUserEnvPkgs = [
      qtbase
      qtsvg
      qtgraphicaleffects
      qtquickcontrols2
    ];

    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/tokyo-night-sddm
    '';
  };

  sddm-firewatch = stdenv.mkDerivation rec {
    pname = "firewatch-sddm";
    version = "V1";
    dontBuild = true;

    src = fetchzip {
      url = "https://github.com/Arana-Jayavihan/firewatch-sddm-theme/archive/refs/tags/V6.zip";
      hash = "sha256-SGnQ2yL2yMe4tMrW6mVcYRLLzZS9Oayi4Zk/cPYSbxk=";
    };

    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/sddm-firewatch
    '';
  };
##____________________________________________________________________________________________

  sddm-astronaut = stdenv.mkDerivation rec {
    pname = "sddm-astronaut-theme";
    version = "1.0";

    src = fetchFromGitHub {
      owner = "vamsi9955"; 
      repo = "sddm-astronaut-theme"; 
      rev = "8f41a83"; 
      sha256 = "sha256-JoSOrTJJYThwCKSPBwj9exhejg/ASY6s9iDcJ+zn8ME=";    
 };

  #installPhase = ''
  #    mkdir -p $out/share/sddm/themes
  #    cp -r $src $out/share/sddm/themes/sddm-astronaut-theme
  #  '';




# Define the installPhase explicitly
  installPhase = ''
    # Create the output directory for the theme
    mkdir -p $out/share/sddm/themes/sddm-astronaut-theme

    # Copy all files from the source to the output directory
    cp -r ./* $out/share/sddm/themes/sddm-astronaut-theme

    # Create the metadata.desktop file with the correct permissions
    cat > $out/share/sddm/themes/sddm-astronaut-theme/metadata.desktop <<EOF
[SddmGreeterTheme]
Name=sddm-astronaut-theme
Description=sddm-astronaut-theme
Author=vamsi9955
License=GPL-3.0-or-later
Type=sddm-theme
Version=1.0
Screenshot=Previews/preview.png
MainScript=Main.qml
ConfigFile=Themes/cyberpunk.conf
TranslationsDirectory=translations
Theme-Id=sddm-astronaut-theme
Theme-API=2.0
QtVersion=6
EOF

    # Ensure all files have the correct permissions
    chmod -R u+rwX,go+rX $out/share/sddm/themes/sddm-astronaut-theme
  '';

};

}
