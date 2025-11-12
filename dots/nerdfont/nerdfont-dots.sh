#! /bin/bash

source ./components/print.sh

# --- OS Detection ---
OS="$(uname -s)"
FONT_DIR=""
DOWNLOAD_CMD=""

if [ "$OS" = "Darwin" ]; then
  FONT_DIR="$HOME/Library/Fonts"
  if command -v curl &>/dev/null; then
    DOWNLOAD_CMD="curl -L -o"
  else
    print_warning "curl is not installed! Skipping font downloads."
    exit 1
  fi
elif [ "$OS" = "Linux" ]; then
  FONT_DIR="$HOME/.local/share/fonts"
  if command -v wget &>/dev/null; then
    DOWNLOAD_CMD="wget -P" # wget -P puts files in specified directory
  elif command -v curl &>/dev/null; then
    DOWNLOAD_CMD="curl -L -o" # curl -o needs full path
  else
    print_warning "Neither wget nor curl is installed! Skipping font downloads."
    exit 1
  fi
else
  print_warning "Unsupported OS: $OS. Skipping font downloads."
  exit 1
fi

# --- Check for unzip ---
if ! command -v unzip &>/dev/null; then
  print_warning "unzip is not installed! Skipping font downloads."
  exit 1
fi

# --- Create font directory ---
mkdir -p "$FONT_DIR"

# --- Function to download and install a font ---
install_nerd_font() {
  local font_name="$1"
  local zip_url="$2"
  local target_dir="$FONT_DIR/$font_name"

  # Extract filename from URL
  local actual_zip_filename=$(basename "$zip_url") # e.g., IosevkaTerm.zip
  local zip_file="$FONT_DIR/$actual_zip_filename" # This is the correct path to the downloaded file

  # Check if font is already installed
  if [ -d "$target_dir" ] && [ -n "$(ls -A "$target_dir")" ]; then
    print_info "$font_name already installed. Skipping."
    return 0
  fi

  print_info "Installing $font_name..."

  # Download
  if [ "$DOWNLOAD_CMD" = "wget -P" ]; then
    $DOWNLOAD_CMD "$FONT_DIR" "$zip_url"
  elif [ "$DOWNLOAD_CMD" = "curl -L -o" ]; then
    $DOWNLOAD_CMD "$zip_file" "$zip_url"
  fi

  if [ ! -f "$zip_file" ]; then
    print_warning "Failed to download $font_name. Skipping."
    return 1
  fi

  # Unzip
  mkdir -p "$target_dir"
  print_info "Attempting to unzip $zip_file to $target_dir"
  if ! unzip -o "$zip_file" -d "$target_dir" 2>&1; then
    print_warning "Unzip failed for $font_name. Check output above for details."
    rm -rf "$target_dir" # Clean up partially unzipped directory
    return 1
  fi
  rm "$zip_file"

  if [ ! -d "$target_dir" ] || [ -z "$(ls -A "$target_dir")" ]; then
    print_warning "$font_name not installed correctly!"
    return 1
  else
    print_success "$font_name installed."
  fi
  return 0
}

# --- Main installation calls ---
install_nerd_font "NerdFontsSymbolsOnly" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip"
install_nerd_font "IosevkaTermNerdFont" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/IosevkaTerm.zip"
install_nerd_font "IosevkaNerdFont" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Iosevka.zip"
install_nerd_font "CascadiaCodeNerdFont" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip"
install_nerd_font "CascadiaMonoNerdFont" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaMono.zip"
install_nerd_font "UbuntuMonoNerdFont" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/UbuntuMono.zip"
install_nerd_font "UbuntuNerdFont" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Ubuntu.zip"
install_nerd_font "HackNerdFont" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip"
install_nerd_font "JetBrainsMonoNerdFont" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"

# --- Update font cache on Linux ---
if [ "$OS" = "Linux" ]; then
  print_info "Updating font cache..."
  fc-cache -fv || print_warning "Failed to update font cache."
fi

print_success "NerdFonts: Dotfiles setup completed!"