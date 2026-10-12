#!/bin/sh
# uninstall.sh — remove NOTHING symlinks/copies and restore the newest backup.
set -eu

REPO_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
BACKUP_ROOT="$HOME/.config_backup/nothing"
DRY_RUN=0
BACKUP=""

usage() {
    cat <<'EOF'
Usage: uninstall.sh [--dry-run] [--backup NAME]

Restores the backup taken by install.sh (default: the newest one) and
removes every symlink the installer created. Files that were copied
(theme fragments, fuzzel.ini) are replaced by their backed-up originals;
if no backup exists for a copied file it is left in place and reported.
EOF
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        --dry-run) DRY_RUN=1 ;;
        --backup) BACKUP="${2:-}"; shift ;;
        --backup=*) BACKUP="${1#--backup=}" ;;
        -h|--help) usage; exit 0 ;;
        *) echo "uninstall: unknown option '$1'" >&2; usage >&2; exit 1 ;;
    esac
    shift
done

if [ -z "$BACKUP" ]; then
    # Newest backup that actually contains files (install.sh prunes
    # empty runs, but stay robust against them anyway).
    for cand in $(ls -1 "$BACKUP_ROOT" 2>/dev/null | sort -r); do
        if [ -n "$(find "$BACKUP_ROOT/$cand" -mindepth 1 -print -quit 2>/dev/null)" ]; then
            BACKUP="$cand"
            break
        fi
    done
fi
if [ -z "$BACKUP" ] || [ ! -d "$BACKUP_ROOT/$BACKUP" ]; then
    echo "uninstall: no backup found under $BACKUP_ROOT — nothing to restore." >&2
    echo "uninstall: symlinks were NOT removed. Pass --backup NAME if needed." >&2
    exit 1
fi
SRC="$BACKUP_ROOT/$BACKUP"
echo "uninstall: restoring from $SRC"

LINKED=".config/hypr/hyprland.conf .config/hypr/appearance.conf .config/hypr/keybinds.conf
.config/hypr/autostart.conf .config/hypr/monitors.conf .config/hypr/hyprpaper.conf
.config/kitty/kitty.conf
.config/fish/config.fish .config/fish/conf.d/00-env.fish .config/fish/conf.d/10-aliases.fish
.config/fish/conf.d/20-prompt.fish .config/fish/conf.d/30-startup.fish
.config/yazi/yazi.toml .config/yazi/keymap.toml
.config/waybar/config.jsonc .config/waybar/style.css
.config/swaync/config.json .config/swaync/style.css
.config/fastfetch/config.jsonc .config/fastfetch/nothing-logo.txt
.local/bin/miniland .local/bin/nothing-theme-switch .local/bin/nothing-weather"
# functions dir handled with a glob below.

remove_link() {
    dest="$HOME/$1"
    if [ -L "$dest" ]; then
        if [ "$DRY_RUN" -eq 1 ]; then
            echo "dry-run: unlink $dest"
        else
            rm -- "$dest"
            echo "uninstall: unlinked $dest"
        fi
    fi
}

for rel in $LINKED; do
    remove_link "$rel"
done
for fn in "$HOME"/.config/fish/functions/*.fish; do
    [ -L "$fn" ] || continue
    target="$(readlink -- "$fn")"
    case "$target" in
        "$REPO_DIR"/*)
            if [ "$DRY_RUN" -eq 1 ]; then echo "dry-run: unlink $fn"; else rm -- "$fn"; echo "uninstall: unlinked $fn"; fi
            ;;
    esac
done

restore() {
    rel="$1"
    backup_file="$SRC/$rel"
    dest="$HOME/$rel"
    if [ -e "$backup_file" ] || [ -L "$backup_file" ]; then
        if [ "$DRY_RUN" -eq 1 ]; then
            echo "dry-run: restore $dest from backup"
        else
            mkdir -p "$(dirname -- "$dest")"
            rm -f -- "$dest"
            cp -a -- "$backup_file" "$dest"
            echo "uninstall: restored $dest"
        fi
    else
        echo "uninstall: no backup for $dest — left as-is"
    fi
}

# Everything the installer may have created (linked or copied).
restore ".config/hypr/hyprland.conf"
restore ".config/hypr/appearance.conf"
restore ".config/hypr/keybinds.conf"
restore ".config/hypr/autostart.conf"
restore ".config/hypr/monitors.conf"
restore ".config/hypr/hyprpaper.conf"
restore ".config/hypr/nothing-wallpaper.png"
restore ".config/hypr/nothing-theme.conf"
restore ".config/kitty/kitty.conf"
restore ".config/kitty/nothing-theme.conf"
restore ".config/fish/config.fish"
restore ".config/fish/nothing-theme.fish"
restore ".config/fuzzel/fuzzel.ini"
restore ".config/yazi/theme.toml"
restore ".config/waybar/nothing-theme.css"
restore ".config/swaync/nothing-theme.css"
restore ".local/bin/miniland"

echo "uninstall: done. Restart affected apps (hyprctl reload, new fish session) to pick up restored configs."
