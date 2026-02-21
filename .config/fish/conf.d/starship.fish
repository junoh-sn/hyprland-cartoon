# ~/.config/fish/conf.d/starship.fish

if command -q starship
    # Initialiser Starship
    starship init fish | source

    # Configurer le rendu des caractères spéciaux
    set -gx STARSHIP_CONFIG ~/.config/starship.toml
end
