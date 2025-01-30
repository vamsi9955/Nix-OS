{
  pkgs ? import <nixpkgs> { config.allowUnfree = true; },
}:

pkgs.mkShell {
  buildInputs = with pkgs; [
    python3
    python3Packages.pip
    python3Packages.virtualenv # Add virtualenv for isolated environments
    gcc # Provides libstdc++
    libffi # Required for some Python packages
    zlib # Compression library often needed for Jupyter
    openssl
    cudatoolkit
  ];

  shellHook = ''
    if [ ! -d ".venv" ]; then
      echo "Creating virtual environment..."
      python -m venv .venv
      source .venv/bin/activate
      echo "Installing latest NumPy and PyTorch via pip..."
      
      pip install --upgrade pip
      pip install  numpy torch torchvision torchaudio stable-baselines3 tensorboard pandas jupyter notebook platformdirs ipykernel matplotlib gym scikit-learn ray[rllib] wandb mujoco

    else
      echo "Activating existing virtual environment..."
      source .venv/bin/activate
    fi
       export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.cudatoolkit.lib}/lib:$LD_LIBRARY_PATH"
        # Add CUDA runtime libraries to LD_LIBRARY_PATH
       export LD_LIBRARY_PATH="/run/opengl-driver/lib:${pkgs.cudatoolkit.lib}/lib:$LD_LIBRARY_PATH"
  '';
}
