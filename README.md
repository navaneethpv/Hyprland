# 🌸 Hyprland Dotfiles & Full System Setup

A modern, cohesive, and feature-rich Hyprland desktop environment tailored for Arch Linux, featuring a Catppuccin Mocha aesthetic, custom Waybar status bar, Rofi application launcher, transparent Kitty terminal, atmospheric Hyprlock screen, and Fish shell.

---

## ⚡ Quick Start (Fresh OS Installation & Full Restoration)

When you reinstall your OS, you can get all your applications, custom fonts, desktop configurations, and system services in one single command.

### 1. One-Step Automated Setup

Open a terminal on your fresh Arch Linux install and run:

```bash
git clone https://github.com/navaneethpv/Hyprland.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

> [!TIP]
> For a completely unattended, non-interactive installation (answers "yes" to all package and service prompts), run:
> ```bash
> ./install.sh -y
> ```

---

## 📦 What Gets Installed & Configured

### 🖥️ Desktop & Window Management
- **Hyprland** (Wayland Compositor)
- **Hyprpaper** (Wallpaper Manager)
- **Hyprlock** & **Hypridle** (Screen locking & idle daemon)
- **Waybar** (Custom Mechabar-themed status bar)
- **Rofi** (Application launcher & clipboard menu)
- **XDG Desktop Portal Hyprland**, **Polkit Gnome**, **Qt5/6 Wayland**

### 💻 Applications & Development Tools
- **Browsers & Editors**: Google Chrome (`google-chrome`), Visual Studio Code (`visual-studio-code-bin`), Mousepad (`mousepad`)
- **Graphics & Viewers**: Krita (`krita`), Loupe image viewer (`loupe`), Swappy screenshot editor (`swappy`)
- **File Management**: Thunar (`thunar`) with Tumbler thumbnail generator (`tumbler`)
- **Terminals & Shells**: Kitty (`kitty`), Alacritty (`alacritty`), Fish (`fish`), Zsh (`zsh`)
- **CLI Utilities**: `fastfetch`, `eza`, `bat`, `ripgrep`, `fd`, `fzf`, `tree`, `jq`, `7zip`, `unzip`, `zip`, `wget`, `curl`, `git`

### 🔤 Custom Fonts & Typography
- **Repository Fonts** deployed directly to `~/.local/share/fonts/`:
  - **Samurai Pack**: *Shippori Mincho*, *Kaushan Script*, *Space Grotesk*, *Syne*
  - **DSEG Pack**: *DSEG7*, *DSEG14*, *Weather Fonts*
- **Official & AUR Fonts**:
  - `ttf-jetbrains-mono-nerd`
  - `ttf-font-awesome`
  - `otf-commit-mono-nerd`

### ⚙️ System Services & Drivers
- **Audio**: PipeWire (`pipewire`, `pipewire-pulse`, `pipewire-alsa`, `pipewire-jack`, `wireplumber`, `playerctl`)
- **Networking & Bluetooth**: NetworkManager (`NetworkManager.service`), Bluetooth (`bluetooth.service`)
- **Power Management**: `power-profiles-daemon`, `brightnessctl`
- **GPU Drivers**: Auto-detects NVIDIA (DKMS), Intel, or AMD graphics and installs appropriate drivers and Vulkan packages.
- **Default Shell**: Automatically sets **Fish** as your default login shell.

---

## 🛠️ Installation Flags & Options

| Option | Description |
| :--- | :--- |
| `./install.sh` | Interactive full installation (packages, fonts, configs, services) |
| `./install.sh -y` | Non-interactive mode (auto-accepts prompts for fully automated installs) |
| `./install.sh --no-pkg` | Skips package installation; only deploys fonts, symlinks configs, and configures services |
| `./install.sh --only-links` | Only backs up existing `~/.config` files and creates symlinks |
| `./install.sh --no-gpu` | Skips GPU driver auto-detection and installation |
| `./install.sh --no-backup` | Overwrites existing configurations without creating backup archives |
| `./install.sh --help` | Displays help message and available options |

---

## ⌨️ Keybindings Cheat Sheet

### 🚀 Applications & Launchers
| Keybinding | Action |
| :--- | :--- |
| <kbd>SUPER</kbd> + <kbd>D</kbd> | Open App Launcher (**Rofi**) |
| <kbd>ALT</kbd> + <kbd>T</kbd> | Launch Terminal (**Kitty**) |
| <kbd>SUPER</kbd> + <kbd>E</kbd> | Open File Manager (**Thunar**) |
| <kbd>ALT</kbd> + <kbd>G</kbd> | Open Google Chrome |
| <kbd>ALT</kbd> + <kbd>V</kbd> | Open IDE / Code |
| <kbd>SUPER</kbd> + <kbd>W</kbd> | Open WhatsApp Web in Chrome |
| <kbd>SUPER</kbd> + <kbd>C</kbd> | Open ChatGPT in Chrome |
| <kbd>SUPER</kbd> + <kbd>H</kbd> | Open Clipboard History (**Cliphist / Rofi**) |
| <kbd>SUPER</kbd> + <kbd>SHIFT</kbd> + <kbd>H</kbd> | Wipe Clipboard History |

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
├── fish/                # Fish shell configuration & prompt
│   ├── config.fish
│   └── fish_variables
├── fonts/               # Custom font packs
│   ├── dseg/            # DSEG digital clock & weather fonts
│   └── samurai/         # Atmospheric typography (Shippori, Kaushan, Space Grotesk, Syne)
├── hypr/                # Hyprland core configuration
│   ├── avatar.png       # Lockscreen avatar image
│   ├── hyprland.lua     # Hyprland window manager rules & keybinds
│   ├── hyprlock.conf    # Aesthetic lockscreen configuration
│   ├── hyprpaper.conf   # Wallpaper manager daemon config
│   ├── mocha.conf       # Catppuccin Mocha color definitions
│   └── scripts/         # Clipboard, wallpaper switch, & power scripts
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
