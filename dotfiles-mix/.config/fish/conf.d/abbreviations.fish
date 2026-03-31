# ~/.config/fish/conf.d/abbreviations.fish

# -----------------------------------------------------------------------------
# EZA (remplace ls)
# -----------------------------------------------------------------------------

# Base
abbr -a l eza
abbr -a ls 'eza --group-directories-first'
abbr -a la 'eza -a --group-directories-first'
abbr -a ll 'eza -l --group --header --group-directories-first'
abbr -a lla 'eza -la --group --header --group-directories-first'
abbr -a lt 'eza --tree --group-directories-first --level=2'
abbr -a lta 'eza --tree --group-directories-first --level=2 -a'
abbr -a lt3 'eza --tree --group-directories-first --level=3'
abbr -a llt 'eza -l --tree --group --header --group-directories-first --level=2'

# Avec icônes (si tu utilises une Nerd Font)
abbr -a li 'eza --icons --group-directories-first'
abbr -a lli 'eza -l --icons --group --header --group-directories-first'
abbr -a llai 'eza -la --icons --group --header --group-directories-first'
abbr -a lai 'eza -a --icons --group-directories-first'
abbr -a lti 'eza --tree --icons --group-directories-first --level=2'

# Git aware
abbr -a lg 'eza -l --group --header --group-directories-first --git --git-ignore'
abbr -a lga 'eza -la --group --header --group-directories-first --git'
abbr -a llg 'eza -l --group --header --group-directories-first --git'

# Dossiers uniquement
abbr -a ld 'eza -D --group-directories-first'
abbr -a lld 'eza -lD --group --header --group-directories-first'
abbr -a lda 'eza -Da --group-directories-first'

# Tailles lisibles + tri par taille
abbr -a lsize 'eza -l --group --header --group-directories-first --total-size'
abbr -a lsort 'eza -l --group --header --group-directories-first --sort=size'
abbr -a ltime 'eza -l --group --header --group-directories-first --sort=modified'

# Combinés populaires
abbr -a lat 'eza -la --group --header --group-directories-first --tree --level=2'
abbr -a lati 'eza -la --icons --group --header --group-directories-first --tree --level=2'
abbr -a lx 'eza -la --group --header --group-directories-first --extended'

# -----------------------------------------------------------------------------
# RACCOURCI CONFIG HYPR (ta demande spécifique)
# -----------------------------------------------------------------------------
abbr -a hyprmods 'nvim ~/.config/hypr/modules'
abbr -a hmod 'nvim ~/.config/hypr/modules'
abbr -a hyprconf 'cd ~/.config/hypr && nvim .'
abbr -a fishconf 'nvim ~/.config/fish/config.fish'
abbr -a fishabbr 'nvim ~/.config/fish/conf.d/abbreviations.fish'
abbr -a kittyconf 'nvim ~/.config/kitty/kitty.conf'
abbr -a nvimconf 'cd ~/.config/nvim && nvim .'

# -----------------------------------------------------------------------------
# Gestionnaire de paquets (Arch)
# -----------------------------------------------------------------------------
abbr -a p pacman
abbr -a ps 'pacman -Ss'
abbr -a pi 'sudo pacman -S'
abbr -a pr 'sudo pacman -Rns'
abbr -a pu 'sudo pacman -Syu'
abbr -a paclean 'sudo pacman -Sc'

# Yay (AUR)
abbr -a y yay
abbr -a ys 'yay -Ss'
abbr -a yi 'yay -S'
abbr -a yu 'yay -Syu'

# -----------------------------------------------------------------------------
# Navigation rapide
# -----------------------------------------------------------------------------
abbr -a .. 'cd ..'
abbr -a ... 'cd ../..'
abbr -a .... 'cd ../../..'
abbr -a ..... 'cd ../../../..'
abbr -a ~ 'cd ~'
abbr -a - 'cd -'

# -----------------------------------------------------------------------------
# Git
# -----------------------------------------------------------------------------
abbr -a g git
abbr -a gs 'git status'
abbr -a ga 'git add'
abbr -a gaa 'git add --all'
abbr -a gc 'git commit -m'
abbr -a gca 'git commit --amend'
abbr -a gp 'git push'
abbr -a gpl 'git pull'
abbr -a gco 'git checkout'
abbr -a gb 'git branch'
abbr -a gd 'git diff'
abbr -a gl 'git log --oneline --graph --decorate -15'
abbr -a gll 'git log --oneline --graph --decorate'

# -----------------------------------------------------------------------------
# Utilitaires
# -----------------------------------------------------------------------------
abbr -a c clear
abbr -a e exit
abbr -a v nvim
abbr -a vi nvim
abbr -a vim nvim
abbr -a cat 'bat --style=plain'
abbr -a catf bat
abbr -a rg 'rg --smart-case'
abbr -a mkdir 'mkdir -p'
abbr -a cp 'cp -i'
abbr -a mv 'mv -i'
abbr -a rm 'rm -i'
abbr -a df 'df -h'
abbr -a du 'du -h'
abbr -a free 'free -h'
abbr -a top btop
abbr -a htop btop
abbr -a n nnn
abbr -a r ranger

# Rechercher dans l'historique
abbr -a h 'history | fzf'
abbr -a fh 'history --search'

# Extraire archives
abbr -a untar 'tar -xvf'
abbr -a untargz 'tar -xzf'
abbr -a ungz gunzip

# IP publique
abbr -a myip 'curl -s https://ipinfo.io/ip'

# -----------------------------------------------------------------------------
# Sudo automatique pour commandes qui en ont besoin
# -----------------------------------------------------------------------------
function sudo_abbr --on-event fish_preexec
    set -l cmd (commandline -opc)
    if test (count $cmd) -eq 1
        switch $cmd[1]
            case pacman systemctl reboot shutdown poweroff
                commandline -r "sudo $cmd"
        end
    end
end
