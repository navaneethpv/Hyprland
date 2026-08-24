# 🌸 Hyprland Dotfiles

A modern, cohesive, and feature-rich Hyprland desktop environment tailored for Arch Linux, featuring a Catppuccin Mocha aesthetic, custom Waybar status bar, Rofi application launcher, transparent Kitty terminal, atmospheric Hyprlock screen, and Fish shell.

---

## ⚡ Quick Start (Fresh Installation / Restoration)

On a fresh Arch Linux installation (or to restore your desktop environment from scratch), clone the repository and run the automated installer:

```bash
git clone https://github.com/navaneethpv/Hyprland.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

### Installation Options

The `install.sh` script provides several flags for flexibility:

| Option | Description |
| :--- | :--- |
| `./install.sh` | Full interactive setup (installs packages, fonts, symlinks configs, enables services) |
| `./install.sh -y` | Non-interactive mode (automatically answers yes to all prompts) |
| `./install.sh --only-links` | Only back up existing `~/.config` files and create symlinks (skips package installs) |
| `./install.sh --no-pkg` | Skip package installation but install fonts and symlink configs |
| `./install.sh --no-backup` | Overwrite existing configurations without creating backup archives |
| `./install.sh --help` | Display usage options and help menu |

---

## ✨ Features

- **Automated Bootstrapping**: Automatically installs official repository packages and bootstraps `yay` (if missing) for AUR packages.
- **Custom Font Suite**: Includes atmospheric typography packs (*Kaushan Script*, *Shippori Mincho*, *Space Grotesk*, *Syne*, *DSEG*, *CommitMono Nerd Font*, and *JetBrainsMono Nerd Font*).
- **Safe & Non-Destructive**: Backs up any conflicting `~/.config/` folders to timestamped backup directories (`~/.config/dotfiles_backup_<timestamp>`).
- **Live Symlinking**: Configs are symlinked directly to `~/.config/`, so editing files in `~/dotfiles` reflects in real-time.
- **Audio & Bluetooth Ready**: Automatically configures and enables `pipewire`, `wireplumber`, `NetworkManager`, and `bluetooth` services.

---

## ⌨️ Keybindings Cheat Sheet

### 🚀 Applications & Launchers
| Keybinding | Action |
| :--- | :--- |
| <kbd>SUPER</kbd> + <kbd>D</kbd> | Open App Launcher (**Rofi**) |
| <kbd>ALT</kbd> + <kbd>T</kbd> | Launch Terminal (**Kitty**) |
| <kbd>SUPER</kbd> + <kbd>E</kbd> | Open File Manager (**Thunar**) |
| <kbd>ALT</kbd> + <kbd>G</kbd> | Open Google Chrome |
| <kbd>SUPER</kbd> + <kbd>W</kbd> | Open WhatsApp Web in Chrome |
| <kbd>SUPER</kbd> + <kbd>C</kbd> | Open ChatGPT in Chrome |

### 🪟 Window Management
| Keybinding | Action |
| :--- | :--- |
| <kbd>SUPER</kbd> + <kbd>Q</kbd> | Close Focused Window |
| <kbd>SUPER</kbd> + <kbd>F</kbd> | Toggle Fullscreen |
| <kbd>SUPER</kbd> + <kbd>V</kbd> | Toggle Floating Window |
| <kbd>SUPER</kbd> + <kbd>P</kbd> | Toggle Pseudo-Tiling |
| <kbd>SUPER</kbd> + <kbd>J</kbd> | Toggle Split (Dwindle layout) |
| <kbd>SUPER</kbd> + <kbd>Left</kbd> / <kbd>Right</kbd> / <kbd>Up</kbd> / <kbd>Down</kbd> | Move Window Focus |
| <kbd>SUPER</kbd> + <kbd>1</kbd> - <kbd>9</kbd>, <kbd>0</kbd> | Switch Workspace (1–10) |
| <kbd>SUPER</kbd> + <kbd>SHIFT</kbd> + <kbd>1</kbd> - <kbd>9</kbd>, <kbd>0</kbd> | Move Active Window to Workspace |
| <kbd>SUPER</kbd> + <kbd>LMB Drag</kbd> | Move Window |
| <kbd>SUPER</kbd> + <kbd>RMB Drag</kbd> | Resize Window |

### 🔒 Session & System Controls
| Keybinding | Action |
| :--- | :--- |
| <kbd>SUPER</kbd> + <kbd>L</kbd> | Lock Screen (**Hyprlock**) |
| <kbd>SUPER</kbd> + <kbd>SHIFT</kbd> + <kbd>L</kbd> | Lock Screen & Suspend System |
| <kbd>SUPER</kbd> + <kbd>B</kbd> | Toggle Waybar Visibility |
| <kbd>PRINT</kbd> | Full Screenshot → Swappy Editor |
| <kbd>CTRL</kbd> + <kbd>PRINT</kbd> | Area Screenshot (Slurp) → Swappy Editor |
| <kbd>SUPER</kbd> + <kbd>SHIFT</kbd> + <kbd>P</kbd> | Power Off System |
| <kbd>SUPER</kbd> + <kbd>SHIFT</kbd> + <kbd>R</kbd> | Reboot System |

---

## 📂 Repository Structure

```
├── fastfetch/           # Fastfetch system info layout & Catppuccin theme
│   └── config.jsonc
├── fish/                # Fish shell configuration
│   └── config.fish
├── fonts/               # Custom font packs
│   ├── dseg/            # DSEG digital clock & weather fonts
│   └── samurai/         # Atmospheric typography (Shippori, Kaushan, Space Grotesk, Syne)
├── hypr/                # Hyprland core configuration
│   ├── avatar.png       # Lockscreen avatar image
│   ├── hyprland.lua     # Hyprland window manager rules & keybinds
│   ├── hyprlock.conf    # Aesthetic lockscreen configuration
│   ├── hyprpaper.conf   # Wallpaper manager daemon config
│   └── mocha.conf       # Catppuccin Mocha color definitions
├── kitty/               # Kitty terminal config with opacity & padding
│   └── kitty.conf
├── rofi/                # Rofi application launcher stylesheet
│   └── theme.rasi
├── walpaper/            # Default wallpapers & lockscreen artwork
│   ├── lockscreen.jpg
│   └── wallpaper.jpg
├── waybar/              # Waybar status bar config, styling, & scripts
│   ├── config.jsonc
│   ├── style.css
│   ├── modules/
│   ├── scripts/
│   └── styles/
├── install.sh           # Automated installation and restoration script
└── README.md
```

---

## 🎨 Customization

- **Wallpaper**: Place your desktop wallpaper at `~/.config/walpaper/wallpaper.jpg` and your lockscreen wallpaper at `~/.config/walpaper/lockscreen.jpg`.
- **Lockscreen Avatar**: Replace `~/.config/hypr/avatar.png` with your desired avatar image.
- **Waybar Modules**: Customize included modules and layouts inside `~/.config/waybar/modules/` and `~/.config/waybar/config.jsonc`.
