#! /bin/bash

source ./components/print.sh

nerdfont_dots_folder=$(dirname "$(realpath "$0")")

print_info "$nerdfont_dots_folder"

if ! command -v wget &>/dev/null; then
  print_warning "wget is not installed! Skipping..."
  exit 1
fi

if ! command -v unzip &>/dev/null; then
  print_warning "unzip is not installed! Skipping..."
  exit 1
fi

mkdir -p ~/.local/share/fonts/

wget -P ~/.local/share/fonts/ https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip
unzip ~/.local/share/fonts/NerdFontsSymbolsOnly.zip -d ~/.local/share/fonts/NerdFontsSymbolsOnly
rm ~/.local/share/fonts/NerdFontsSymbolsOnly.zip
if [ ! -d "$HOME/.local/share/fonts/NerdFontsSymbolsOnly" ]; then
  print_warning "NerdFontsSymbolsOnly not installed!"
fi

wget -P ~/.local/share/fonts/ https://github.com/ryanoasis/nerd-fonts/releases/latest/download/IosevkaTerm.zip
unzip ~/.local/share/fonts/IosevkaTerm.zip -d ~/.local/share/fonts/IosevkaTermNerdFont
rm ~/.local/share/fonts/IosevkaTerm.zip
if [ ! -d "$HOME/.local/share/fonts/IosevkaTermNerdFont" ]; then
  print_warning "IosevkaTermNerdFont not installed!"
fi

wget -P ~/.local/share/fonts/ https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Iosevka.zip
unzip ~/.local/share/fonts/Iosevka.zip -d ~/.local/share/fonts/IosevkaNerdFont
rm ~/.local/share/fonts/Iosevka.zip
if [ ! -d "$HOME/.local/share/fonts/IosevkaNerdFont" ]; then
  print_warning "IosevkaNerdFont not installed!"
fi

wget -P ~/.local/share/fonts/ https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip
unzip ~/.local/share/fonts/CascadiaCode.zip -d ~/.local/share/fonts/CascadiaCodeNerdFont
rm ~/.local/share/fonts/CascadiaCode.zip
if [ ! -d "$HOME/.local/share/fonts/CascadiaCodeNerdFont" ]; then
  print_warning "CascadiaCodeNerdFont not installed!"
fi

wget -P ~/.local/share/fonts/ https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaMono.zip
unzip ~/.local/share/fonts/CascadiaMono.zip -d ~/.local/share/fonts/CascadiaMonoNerdFont
rm ~/.local/share/fonts/CascadiaMono.zip
if [ ! -d "$HOME/.local/share/fonts/CascadiaMonoNerdFont" ]; then
  print_warning "CascadiaMonoNerdFont not installed!"
fi

wget -P ~/.local/share/fonts/ https://github.com/ryanoasis/nerd-fonts/releases/latest/download/UbuntuMono.zip
unzip ~/.local/share/fonts/UbuntuMono.zip -d ~/.local/share/fonts/UbuntuMonoNerdFont
rm ~/.local/share/fonts/UbuntuMono.zip
if [ ! -d "$HOME/.local/share/fonts/UbuntuMonoNerdFont" ]; then
  print_warning "UbuntuMonoNerdFont not installed!"
fi

wget -P ~/.local/share/fonts/ https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Ubuntu.zip
unzip ~/.local/share/fonts/Ubuntu.zip -d ~/.local/share/fonts/UbuntuNerdFont
rm ~/.local/share/fonts/Ubuntu.zip
if [ ! -d "$HOME/.local/share/fonts/UbuntuNerdFont" ]; then
  print_warning "UbuntuNerdFont not installed!"
fi

wget -P ~/.local/share/fonts/ https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip
unzip ~/.local/share/fonts/Hack.zip -d ~/.local/share/fonts/HackNerdFont
rm ~/.local/share/fonts/Hack.zip
if [ ! -d "$HOME/.local/share/fonts/HackNerdFont" ]; then
  print_warning "HackNerdFont not installed!"
fi

wget -P ~/.local/share/fonts/ https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip ~/.local/share/fonts/JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMonoNerdFont
rm ~/.local/share/fonts/JetBrainsMono.zip
if [ ! -d "$HOME/.local/share/fonts/JetBrainsMonoNerdFont" ]; then
  print_warning "JetBrainsMonoNerdFont not installed!"
fi

print_success "NerdFonts: Dotfiles setup completed!"
