#!/usr/bin/env bash
# ==============================================================================
# Hyprland Dotfiles Automated Installation & Restoration Script
# Supports fresh Arch Linux installations and full environment restoration
# ==============================================================================

set -eo pipefail

# Script Directory (Location of dotfiles)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
FONTS_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/fonts"
BACKUP_DIR="${CONFIG_DIR}/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Flags
NON_INTERACTIVE=false
SKIP_PKGS=false
ONLY_LINKS=false
NO_BACKUP=false

# ANSI Color Codes
CLR_RESET=$'\e[0m'
CLR_BOLD=$'\e[1m'
CLR_DIM=$'\e[2m'
CLR_RED=$'\e[31m'
CLR_GREEN=$'\e[32m'
CLR_YELLOW=$'\e[33m'
CLR_BLUE=$'\e[34m'
CLR_MAGENTA=$'\e[35m'
CLR_CYAN=$'\e[36m'

# Logging Functions
log_info() {
    printf "%b[INFO]%b %s\n" "${CLR_CYAN}" "${CLR_RESET}" "$1"
}

log_step() {
    printf "\n%b%b==> %s%b\n" "${CLR_BOLD}" "${CLR_MAGENTA}" "$1" "${CLR_RESET}"
}

log_success() {
    printf "%b[OK]%b   %s\n" "${CLR_GREEN}" "${CLR_RESET}" "$1"
}

log_warn() {
    printf "%b[WARN]%b %s\n" "${CLR_YELLOW}" "${CLR_RESET}" "$1"
}

log_error() {
    printf "%b[ERR]%b  %s\n" "${CLR_RED}" "${CLR_RESET}" "$1" >&2
}

log_skip() {
    printf "%b[SKIP]%b %s\n" "${CLR_DIM}" "${CLR_RESET}" "$1"
}

print_banner() {
    cat << "EOF"

  _    _                  _                 _ 
 | |  | |                | |               | |
 | |__| |_   _ _ __  _ __| | __ _ _ __   __| |
 |  __  | | | | '_ \| '__| |/ _` | '_ \ / _` |
 | |  | | |_| | |_) | |  | | (_| | | | | (_| |
 |_|  |_|\__, | .__/|_|  |_|\__,_|_| |_|\__,_|
          __/ | |                             
         |___/|_|                             
       Fresh Installation & Restore Script
==================================================
EOF
}

print_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Options:
  -y, --yes              Non-interactive mode (answers yes to all prompts)
  --no-pkg, --skip-pkg   Skip package installation (only link configs and install fonts)
  --only-links           Only backup and symlink config folders
  --no-backup            Do not create backups of existing configuration directories
  -h, --help             Show this help message and exit

Description:
  Installs all required dependencies (Hyprland, Waybar, Rofi, Kitty, Fish,
  utilities, audio, fonts), installs custom Samurai & DSEG font packs,
  backs up existing ~/.config entries, and symlinks dotfiles.
EOF
}

# Parse Command Line Arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -y|--yes|--non-interactive)
                NON_INTERACTIVE=true
                shift
                ;;
            --no-pkg|--skip-pkg)
                SKIP_PKGS=true
                shift
                ;;
            --only-links)
                ONLY_LINKS=true
                SKIP_PKGS=true
                shift
                ;;
            --no-backup)
                NO_BACKUP=true
                shift
                ;;
            -h|--help)
                print_help
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                print_help
                exit 1
                ;;
        esac
    done
}

# Confirm Prompt (Respects Non-Interactive Flag)
confirm() {
    local prompt="$1"
    local default="${2:-Y}"

    if [[ "$NON_INTERACTIVE" == true ]]; then
        return 0
    fi

    local response
    if [[ "$default" == "Y" ]]; then
        read -r -p "${prompt} [Y/n]: " response
        response=${response:-Y}
        [[ "$response" =~ ^[yY]([eE][sS])?$ ]]
    else
        read -r -p "${prompt} [y/N]: " response
        response=${response:-N}
        [[ "$response" =~ ^[yY]([eE][sS])?$ ]]
    fi
}

# Check Environment Requirements
check_environment() {
    log_step "Checking System Environment"

    if [[ "$EUID" -eq 0 ]]; then
        log_error "Do not run this script directly as root. Run as regular user with sudo privileges."
        exit 1
    fi

    if ! command -v pacman &>/dev/null; then
        log_error "This script is tailored for Arch Linux and Arch-based distributions (pacman not found)."
        exit 1
    fi

    log_success "Running on Arch Linux as user $(whoami)."

    if [[ "$ONLY_LINKS" == false && "$SKIP_PKGS" == false ]]; then
        log_info "Validating sudo access..."
        sudo -v
        # Keep-alive: update existing `sudo` time stamp until script finishes
        while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
        SUDO_PID=$!
        trap 'kill $SUDO_PID 2>/dev/null || true' EXIT
    fi
}

# Detect or Bootstrap AUR Helper (yay / paru)
setup_aur_helper() {
    if [[ "$SKIP_PKGS" == true ]]; then
        return 0
    fi

    log_step "Checking AUR Helper"

    if command -v yay &>/dev/null; then
        AUR_HELPER="yay"
        log_success "Found AUR helper: yay"
        return 0
    fi

    if command -v paru &>/dev/null; then
        AUR_HELPER="paru"
        log_success "Found AUR helper: paru"
        return 0
    fi

    log_warn "No AUR helper (yay/paru) detected."
    if confirm "Would you like to automatically install yay-bin from AUR?" "Y"; then
        log_info "Installing base-devel and git if missing..."
        sudo pacman -S --needed --noconfirm base-devel git

        local tmp_dir
        tmp_dir=$(mktemp -d)
        log_info "Cloning and building yay-bin in ${tmp_dir}..."
        git clone https://aur.archlinux.org/yay-bin.git "$tmp_dir/yay-bin"
        (cd "$tmp_dir/yay-bin" && makepkg -si --noconfirm)
        rm -rf "$tmp_dir"

        if command -v yay &>/dev/null; then
            AUR_HELPER="yay"
            log_success "yay installed successfully!"
        else
            log_error "Failed to install yay. Please install yay or paru manually."
            exit 1
        fi
    else
        log_warn "Skipping AUR helper installation. AUR packages might fail to install."
        AUR_HELPER=""
    fi
}

# Core Package Lists
OFFICIAL_PACKAGES=(
    # Hyprland & Wayland Base
    hyprland
    hyprpaper
    hyprlock
    xdg-desktop-portal-hyprland
    qt5-wayland
    qt6-wayland
    polkit-gnome
    wl-clipboard

    # Bar & App Launcher
    waybar
    rofi
    fastfetch

    # Shell & Terminal
    kitty
    fish

    # Audio & Media
    pipewire
    pipewire-pulse
    pipewire-alsa
    wireplumber
    playerctl
    libpulse

    # Tools & System Utilities
    brightnessctl
    bluez-utils
    networkmanager
    pacman-contrib
    libnotify
    grim
    slurp
    swappy
    thunar
    tumbler
    fzf
    eza
    bat
    ripgrep
    jq
    unzip
    wget
    curl

    # Official Fonts
    ttf-jetbrains-mono-nerd
    ttf-font-awesome
)

AUR_PACKAGES=(
    google-chrome
    otf-commit-mono-nerd
)

# Install Packages
install_packages() {
    if [[ "$SKIP_PKGS" == true ]]; then
        log_info "Skipping package installation as requested."
        return 0
    fi

    log_step "Installing Official Repository Packages"

    local missing_official=()
    for pkg in "${OFFICIAL_PACKAGES[@]}"; do
        if pacman -Qi "$pkg" &>/dev/null; then
            log_skip "$pkg (already installed)"
        else
            missing_official+=("$pkg")
        fi
    done

    if [[ ${#missing_official[@]} -gt 0 ]]; then
        log_info "Installing ${#missing_official[@]} official packages: ${missing_official[*]}"
        sudo pacman -S --needed --noconfirm "${missing_official[@]}"
        log_success "Official packages installed."
    else
        log_success "All official packages are already installed."
    fi

    if [[ -n "$AUR_HELPER" && ${#AUR_PACKAGES[@]} -gt 0 ]]; then
        log_step "Installing AUR Packages"

        local missing_aur=()
        for pkg in "${AUR_PACKAGES[@]}"; do
            if pacman -Qi "$pkg" &>/dev/null; then
                log_skip "$pkg (already installed)"
            else
                missing_aur+=("$pkg")
            fi
        done

        if [[ ${#missing_aur[@]} -gt 0 ]]; then
            log_info "Installing ${#missing_aur[@]} AUR packages with $AUR_HELPER: ${missing_aur[*]}"
            "$AUR_HELPER" -S --needed --noconfirm "${missing_aur[@]}"
            log_success "AUR packages installed."
        else
            log_success "All AUR packages are already installed."
        fi
    fi
}

# Install Custom Fonts
install_fonts() {
    log_step "Deploying Custom Fonts"

    mkdir -p "$FONTS_DIR"

    if [[ -d "$DOTFILES_DIR/fonts" ]]; then
        log_info "Copying repository custom fonts to $FONTS_DIR..."
        cp -rn "$DOTFILES_DIR/fonts/"* "$FONTS_DIR/" 2>/dev/null || cp -r "$DOTFILES_DIR/fonts/"* "$FONTS_DIR/"
        log_success "Custom font files deployed."
    else
        log_warn "No fonts directory found in dotfiles."
    fi

    log_info "Updating system font cache (fc-cache)..."
    fc-cache -f "$FONTS_DIR"
    log_success "Font cache refreshed."
}

# Backup and Symlink Dotfiles
CONFIG_FOLDERS=(
    "hypr"
    "waybar"
    "rofi"
    "kitty"
    "fastfetch"
    "fish"
    "walpaper"
)

setup_symlinks() {
    log_step "Setting Up Configuration Symlinks"

    mkdir -p "$CONFIG_DIR"
    local has_backups=false

    for folder in "${CONFIG_FOLDERS[@]}"; do
        local src="$DOTFILES_DIR/$folder"
        local dest="$CONFIG_DIR/$folder"

        if [[ ! -e "$src" ]]; then
            log_warn "Source folder $src does not exist in repository, skipping."
            continue
        fi

        # Check if destination exists
        if [[ -e "$dest" || -L "$dest" ]]; then
            # If it's already a symlink pointing to the right place, skip
            if [[ -L "$dest" && "$(readlink -f "$dest")" == "$(readlink -f "$src")" ]]; then
                log_skip "$dest -> already correctly linked"
                continue
            fi

            # Backup existing
            if [[ "$NO_BACKUP" == false ]]; then
                if [[ "$has_backups" == false ]]; then
                    mkdir -p "$BACKUP_DIR"
                    has_backups=true
                    ACTUAL_BACKUP_PATH="$BACKUP_DIR"
                    log_info "Backing up existing configurations to $BACKUP_DIR"
                fi
                log_info "Backing up $dest -> $BACKUP_DIR/$folder"
                mv "$dest" "$BACKUP_DIR/$folder"
            else
                log_warn "Removing existing $dest (backup disabled)"
                rm -rf "$dest"
            fi
        fi

        # Create symlink
        log_info "Linking $src -> $dest"
        ln -sfn "$src" "$dest"
        log_success "Linked $folder"
    done

    # Ensure Waybar helper scripts are executable
    if [[ -d "$DOTFILES_DIR/waybar/scripts" ]]; then
        log_info "Ensuring executable permissions on waybar scripts..."
        chmod +x "$DOTFILES_DIR"/waybar/scripts/* 2>/dev/null || true
    fi

    if [[ -f "$DOTFILES_DIR/waybar/install" ]]; then
        chmod +x "$DOTFILES_DIR/waybar/install" 2>/dev/null || true
    fi

    log_success "Configurations symlinked successfully."
}

# Enable Services
setup_services() {
    if [[ "$ONLY_LINKS" == true ]]; then
        return 0
    fi

    log_step "Configuring System & User Services"

    # Pipewire audio services (user level)
    if command -v systemctl &>/dev/null; then
        log_info "Enabling Pipewire audio services for user session..."
        systemctl --user enable --now pipewire.service pipewire-pulse.service wireplumber.service 2>/dev/null || true
        log_success "Pipewire user services enabled."

        # Bluetooth service
        if pacman -Qi bluez &>/dev/null || pacman -Qi bluez-utils &>/dev/null; then
            if ! systemctl is-enabled bluetooth.service &>/dev/null; then
                if confirm "Would you like to enable the Bluetooth system service?" "Y"; then
                    sudo systemctl enable --now bluetooth.service || true
                    log_success "Bluetooth service enabled."
                fi
            else
                log_skip "Bluetooth service already enabled."
            fi
        fi

        # NetworkManager service
        if pacman -Qi networkmanager &>/dev/null; then
            if ! systemctl is-enabled NetworkManager.service &>/dev/null; then
                if confirm "Would you like to enable the NetworkManager system service?" "Y"; then
                    sudo systemctl enable --now NetworkManager.service || true
                    log_success "NetworkManager service enabled."
                fi
            else
                log_skip "NetworkManager service already enabled."
            fi
        fi
    fi
}

# Configure Default Shell
setup_shell() {
    if [[ "$ONLY_LINKS" == true ]]; then
        return 0
    fi

    log_step "Default Shell Configuration"

    local fish_path
    fish_path=$(command -v fish || true)

    if [[ -n "$fish_path" ]]; then
        if [[ "$SHELL" != "$fish_path" ]]; then
            if confirm "Would you like to set Fish as your default login shell ($fish_path)?" "Y"; then
                if ! grep -q "^$fish_path$" /etc/shells; then
                    log_info "Adding $fish_path to /etc/shells..."
                    echo "$fish_path" | sudo tee -a /etc/shells
                fi
                chsh -s "$fish_path"
                log_success "Default shell changed to Fish."
            else
                log_info "Keeping current shell: $SHELL"
            fi
        else
            log_skip "Fish is already your default shell."
        fi
    fi
}

# Main Execution Flow
main() {
    parse_args "$@"
    print_banner
    check_environment

    if [[ "$ONLY_LINKS" == false && "$SKIP_PKGS" == false ]]; then
        setup_aur_helper
        install_packages
    fi

    install_fonts
    setup_symlinks
    setup_services
    setup_shell

    cat << EOF

${CLR_BOLD}${CLR_GREEN}==================================================
  Installation & Restoration Completed Successfully!
==================================================${CLR_RESET}

${CLR_BOLD}Summary of Actions:${CLR_RESET}
  - Dependencies & AUR packages verified / installed
  - Custom font packs (Samurai & DSEG) installed and cached
  - Dotfiles symlinked into ${CONFIG_DIR}
  - Audio and system services configured

${CLR_BOLD}Quick Launch:${CLR_RESET}
  - Start Hyprland by running: ${CLR_CYAN}Hyprland${CLR_RESET} (or login via display manager)
  - Keybindings:
      - App Launcher:  ${CLR_YELLOW}SUPER + D${CLR_RESET} (Rofi)
      - Terminal:      ${CLR_YELLOW}ALT + T${CLR_RESET} (Kitty)
      - Lock Screen:   ${CLR_YELLOW}SUPER + L${CLR_RESET} (Hyprlock)
      - File Manager:  ${CLR_YELLOW}SUPER + E${CLR_RESET} (Thunar)
      - Waybar Toggle: ${CLR_YELLOW}SUPER + B${CLR_RESET}

EOF

    if [[ -n "$ACTUAL_BACKUP_PATH" ]]; then
        printf "%bIf you need to restore prior configs, a backup was saved to:%b\n" "${CLR_DIM}" "${CLR_RESET}"
        printf "%b%s%b\n\n" "${CLR_CYAN}" "$ACTUAL_BACKUP_PATH" "${CLR_RESET}"
    fi
}

main "$@"
