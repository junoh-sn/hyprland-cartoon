# ~/.config/fish/config.fish
set -gx PATH $PATH /usr/local/bin

# Config exécutée seulement en shell interactif
if status is-interactive

    # Afficher le fetch uniquement dans Kitty
    if test "$TERM" = xterm-kitty
        and not set -q KITTY_FETCH_DONE
        set -gx KITTY_FETCH_DONE 1
        nitch
        echo
    end

end

# Ne pas exécuter en mode non-interactif
if not status is-interactive
    return
end

# -----------------------------------------------------------------------------
# Éditeur par défaut
# -----------------------------------------------------------------------------
set -gx EDITOR nvim
set -gx VISUAL nvim

# -----------------------------------------------------------------------------
# Historique
# -----------------------------------------------------------------------------
set -g fish_history_max 10000
set -g fish_history_file ~/.local/share/fish/fish_history

# -----------------------------------------------------------------------------
# FZF Configuration
# -----------------------------------------------------------------------------
set -gx FZF_DEFAULT_OPTS "\
    --height 60% \
    --layout reverse \
    --border rounded \
    --preview 'bat --color=always --style=numbers --line-range=:500 {}' \
    --preview-window=right:50%:wrap \
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# -----------------------------------------------------------------------------
# Zoxide (cd intelligent)
# -----------------------------------------------------------------------------
if command -q zoxide
    zoxide init fish | source
end

# -----------------------------------------------------------------------------
# Désactiver le message de bienvenue par défaut
# -----------------------------------------------------------------------------
set -g fish_greeting ""

# -----------------------------------------------------------------------------
# Key bindings (Emacs style par défaut)
# -----------------------------------------------------------------------------
set -g fish_key_bindings fish_default_key_bindings

# Ctrl+Backspace pour supprimer le mot précédent
bind \b backward-kill-word
# Ctrl+Delete pour supprimer le mot suivant
bind \e\[3\;5~ kill-word
# Alt+Left/Right pour naviguer par mots
bind \e\[1\;3D backward-word
bind \e\[1\;3C forward-word

# Lancer nitch au démarrage du terminal
if status is-interactive
    nitch
end
