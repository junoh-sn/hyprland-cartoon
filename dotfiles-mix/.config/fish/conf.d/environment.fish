# ~/.config/fish/conf.d/environment.fish

# -----------------------------------------------------------------------------
# PATH
# -----------------------------------------------------------------------------
fish_add_path ~/.local/bin
fish_add_path ~/.cargo/bin
fish_add_path ~/go/bin
fish_add_path ~/.npm-global/bin
fish_add_path ~/.dotnet/tools

# -----------------------------------------------------------------------------
# Polices et terminal
# -----------------------------------------------------------------------------
set -gx TERM xterm-256color
set -gx COLORTERM truecolor

# -----------------------------------------------------------------------------
# Langue/Locale
# -----------------------------------------------------------------------------
set -gx LANG fr_FR.UTF-8
set -gx LC_ALL fr_FR.UTF-8

# -----------------------------------------------------------------------------
# XDG Base Directory
# -----------------------------------------------------------------------------
set -gx XDG_CONFIG_HOME ~/.config
set -gx XDG_DATA_HOME ~/.local/share
set -gx XDG_CACHE_HOME ~/.cache

# -----------------------------------------------------------------------------
# Applications
# -----------------------------------------------------------------------------

# Bat (cat amélioré)
set -gx BAT_THEME "Catppuccin Mocha"
set -gx BAT_STYLE "numbers,changes,header"

# NNN (file manager)
set -gx NNN_OPTS H
set -gx NNN_OPENER "$HOME/.config/nnn/plugins/nuke"
set -gx NNN_FIFO "/tmp/nnn.fifo"

# NPM global sans sudo
set -gx NPM_CONFIG_PREFIX ~/.npm-global

# Rust
set -gx RUSTC_WRAPPER sccache

# Java
set -gx JAVA_HOME /usr/lib/jvm/default

# Flatpak
set -gx FLATPAK_SPAWN_EXTRA_ARGS "--env=TERM=xterm-256color"

# -----------------------------------------------------------------------------
# Wayland / Hyprland
# -----------------------------------------------------------------------------
set -gx MOZ_ENABLE_WAYLAND 1
set -gx QT_QPA_PLATFORM wayland
set -gx QT_QPA_PLATFORMTHEME qt5ct
set -gx SDL_VIDEODRIVER wayland
set -gx _JAVA_AWT_WM_NONREPARENTING 1
set -gx GDK_BACKEND wayland
set -gx XDG_CURRENT_DESKTOP Hyprland
set -gx XDG_SESSION_TYPE wayland
set -gx XDG_SESSION_DESKTOP Hyprland
