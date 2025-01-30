{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  kdePackages,
  theme ? "astronaut",
 }:
stdenvNoCC.mkDerivation rec {
  pname = "sddm-astronaut-theme";
  version = "1.0";

  src = fetchFromGitHub {
      owner = "vamsi9955"; 
      repo = "sddm-astronaut-theme"; 
      rev = "8f41a83"; 
      sha256 = "sha256-JoSOrTJJYThwCKSPBwj9exhejg/ASY6s9iDcJ+zn8ME=";    
 
  };

  # Avoid wrapping Qt binaries
  dontWrapQtApps = true;

  # Required Qt6 libraries for SDDM >= 0.21
  propagatedBuildInputs = [
    kdePackages.qtsvg
    kdePackages.qtmultimedia
    kdePackages.qtvirtualkeyboard
    kdePackages.qt5compat
  ];

  buildPhase = ''
    runHook preBuild
    echo "No build required."
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Install theme to a single directory
    install -dm755 "$out/share/sddm/themes/sddm-astronaut-theme"
    cp -r ./* "$out/share/sddm/themes/sddm-astronaut-theme"

    # Copy fonts system-wide
    install -dm755 "$out/share/fonts"
    cp -r "$out/share/sddm/themes/sddm-astronaut-theme/Fonts/." "$out/share/fonts"

    # Update metadata.desktop to load the chosen subtheme
    metaFile="$out/share/sddm/themes/sddm-astronaut-theme/metadata.desktop"
    if [ -f "$metaFile" ]; then
      substituteInPlace "$metaFile" \
        --replace "ConfigFile=Themes/astronaut.conf" "ConfigFile=Themes/${theme}.conf" 
    fi
     runHook postInstall
  '';

  # Propagate Qt6 libraries to user environment
  postFixup = ''
    mkdir -p $out/nix-support
    echo ${kdePackages.qtsvg} >> $out/nix-support/propagated-user-env-packages
    echo ${kdePackages.qtmultimedia} >> $out/nix-support/propagated-user-env-packages
    echo ${kdePackages.qtvirtualkeyboard} >> $out/nix-support/propagated-user-env-packages
    #echo ${kdePackages.qt5compat} >> $out/nix-support/propagated-user-env-packages
   '';

  meta = with lib; {
    description = "Series of modern looking themes for SDDM.";
    homepage = "https://github.com/Keyitdev/sddm-astronaut-theme";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
##