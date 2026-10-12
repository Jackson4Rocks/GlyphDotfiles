#!/bin/sh
# NOTHING dotfiles — safe, repeatable installer.
# Backs up, symlinks static configs, copies theme files, never uses sudo
# unless you pass --install-deps explicitly.
set -eu

REPO_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
BACKUP_ROOT="$HOME/.config_backup/nothing"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$BACKUP_ROOT/$STAMP"

DRY_RUN=0
THEME=""
INSTALL_DEPS=0
FORCE_OS=0

usage() {
    cat <<'EOF'
Usage: install.sh [--dry-run] [--theme amoled-black|pure-white] [--install-deps] [--force-os]

  --dry-run    Preview every action; change nothing.
  --theme      Skip the interactive theme menu (still echoed back).
  --install-deps
               Install missing packages with pacman (needs sudo).
               Without it, missing tools are only reported.
  --force-os   Run on non-Arch systems (configs still deploy; package
               install stays disabled unless --install-deps is given).
EOF
}

log()  { printf '%s\n' "install: $*"; }
dry()  { if [ "$DRY_RUN" -eq 1 ]; then printf '%s\n' "dry-run: $*"; return 0; fi; return 1; }

while [ "$#" -gt 0 ]; do
    case "$1" in
        --dry-run) DRY_RUN=1 ;;
        --theme) THEME="${2:-}"; shift ;;
        --theme=*) THEME="${1#--theme=}" ;;
        --install-deps) INSTALL_DEPS=1 ;;
        --force-os) FORCE_OS=1 ;;
        -h|--help) usage; exit 0 ;;
        *) echo "install: unknown option '$1'" >&2; usage >&2; exit 1 ;;
    esac
    shift
done

# ── 1. OS gate ───────────────────────────────────────────────────────────
OS_ID="$(grep -E '^ID=' /etc/os-release 2>/dev/null | cut -d= -f2 | tr -d '"' || echo unknown)"
OS_LIKE="$(grep -E '^ID_LIKE=' /etc/os-release 2>/dev/null | cut -d= -f2 | tr -d '"' || echo "")"
case "$OS_ID $OS_LIKE" in
    *arch*|*cachyos*) log "OS supported: $OS_ID" ;;
    *)
        if [ "$FORCE_OS" -eq 1 ]; then
            log "WARNING: unsupported OS ($OS_ID); continuing with --force-os"
        else
            echo "install: unsupported OS '$OS_ID' — these dotfiles target Arch/CachyOS." >&2
            echo "install: re-run with --force-os to deploy configs anyway." >&2
            exit 1
        fi
        ;;
esac

# ── 2. Validate the repo before touching the system ──────────────────────
if [ -x "$REPO_DIR/scripts/check-configs" ]; then
    log "validating repository..."
    if "$REPO_DIR/scripts/check-configs" >/dev/null 2>&1; then
        log "repository checks passed"
    else
        echo "install: repository checks FAILED — run scripts/check-configs and fix before installing." >&2
        exit 1
    fi
fi

# ── 3. Dependency audit (informational unless --install-deps) ─────────────
REQUIRED="hyprland fish kitty"
OPTIONAL="yazi fastfetch waybar fuzzel swaync jq grim slurp swappy wl-copy cliphist hyprlock hyprpaper hypridle brightnessctl pamixer playerctl eza zoxide fzf bat"
MISSING_REQ=""
MISSING_OPT=""
for b in $REQUIRED; do
    command -v "$b" >/dev/null 2>&1 || MISSING_REQ="$MISSING_REQ $b"
done
for b in $OPTIONAL; do
    command -v "$b" >/dev/null 2>&1 || MISSING_OPT="$MISSING_OPT $b"
done
if [ -n "$MISSING_REQ" ]; then
    echo "install: missing REQUIRED tools:$MISSING_REQ" >&2
    if [ "$INSTALL_DEPS" -eq 1 ]; then
        log "installing:$MISSING_REQ$MISSING_OPT"
        if dry "pacman -S --needed$ MISSING_REQ$MISSING_OPT"; then :; else
            sudo pacman -S --needed $MISSING_REQ $MISSING_OPT
        fi
    else
        echo "install: install them yourself, or re-run with --install-deps (uses sudo)." >&2
        echo "install: continuing — configs deploy regardless." >&2
    fi
elif [ -n "$MISSING_OPT" ] && [ "$INSTALL_DEPS" -eq 1 ]; then
    log "installing optional:$MISSING_OPT"
    if dry "pacman -S --needed$MISSING_OPT"; then :; else
        sudo pacman -S --needed $MISSING_OPT
    fi
elif [ -n "$MISSING_OPT" ]; then
    log "optional tools missing (features degrade gracefully):$MISSING_OPT"
fi

# ── 4. Theme choice (interactive menu, valid choice required) ─────────────
if [ -z "$THEME" ]; then
    if [ ! -t 0 ]; then
        echo "install: no --theme given and stdin is not a terminal." >&2
        exit 1
    fi
    echo "1. AMOLED BLACK — Pure black, white text"
    echo "2. PURE WHITE — Pure white, black text"
    printf 'Choose 1 or 2: '
    read -r choice
    case "$choice" in
        1) THEME="amoled-black" ;;
        2) THEME="pure-white" ;;
        *) echo "install: invalid choice — enter 1 or 2." >&2; exit 1 ;;
    esac
fi
case "$THEME" in
    amoled-black|pure-white) log "theme selected: $THEME" ;;
    *) echo "install: invalid --theme '$THEME'" >&2; exit 1 ;;
esac

# ── 5. Backups ───────────────────────────────────────────────────────────
do_backup() {
    bk_src="$1"
    [ -e "$bk_src" ] || [ -L "$bk_src" ] || return 0
    bk_rel="${bk_src#$HOME/}"
    bk_dest="$BACKUP_DIR/$bk_rel"
    if dry "backup $bk_src -> $bk_dest"; then return 0; fi
    mkdir -p "$(dirname -- "$bk_dest")"
    mv "$bk_src" "$bk_dest"
    log "backed up $bk_src"
}

# ── 6. Deploy helpers ────────────────────────────────────────────────────
# link_file <repo-relative> <home-relative>: symlink static configs.
link_file() {
    lf_src="$REPO_DIR/$1"
    lf_dest="$HOME/$2"
    [ -e "$lf_src" ] || { echo "install: repo file missing: $1" >&2; exit 1; }
    if [ -L "$lf_dest" ] && [ "$(readlink -- "$lf_dest")" = "$lf_src" ]; then
        log "already linked: $lf_dest"
        return 0
    fi
    do_backup "$lf_dest"
    if dry "link $lf_dest -> $lf_src"; then return 0; fi
    mkdir -p "$(dirname -- "$lf_dest")"
    ln -s "$lf_src" "$lf_dest"
    log "linked $lf_dest"
}

# copy_file <repo-relative> <home-relative>: for generated/managed files.
copy_file() {
    cp_src="$REPO_DIR/$1"
    cp_dest="$HOME/$2"
    [ -e "$cp_src" ] || { echo "install: repo file missing: $1" >&2; exit 1; }
    if [ -f "$cp_dest" ] && cmp -s "$cp_src" "$cp_dest"; then
        log "already current: $cp_dest"
        return 0
    fi
    do_backup "$cp_dest"
    if dry "copy $cp_src -> $cp_dest"; then return 0; fi
    mkdir -p "$(dirname -- "$cp_dest")"
    cp "$cp_src" "$cp_dest"
    log "installed $cp_dest"
}

if [ "$DRY_RUN" -eq 0 ]; then
    mkdir -p "$BACKUP_DIR"
    log "backups go to $BACKUP_DIR"
fi

# ── 7. Static configs (symlinks — edit the repo, changes apply) ──────────
link_file "config/hypr/hyprland.conf"   ".config/hypr/hyprland.conf"
link_file "config/hypr/appearance.conf" ".config/hypr/appearance.conf"
link_file "config/hypr/keybinds.conf"   ".config/hypr/keybinds.conf"
link_file "config/hypr/autostart.conf"  ".config/hypr/autostart.conf"
link_file "config/hypr/hyprpaper.conf"  ".config/hypr/hyprpaper.conf"
# monitors.conf is personal: link only when the user has none.
if [ -e "$HOME/.config/hypr/monitors.conf" ] || [ -L "$HOME/.config/hypr/monitors.conf" ]; then
    log "keeping existing .config/hypr/monitors.conf"
else
    link_file "config/hypr/monitors.conf" ".config/hypr/monitors.conf"
fi

link_file "config/kitty/kitty.conf" ".config/kitty/kitty.conf"

link_file "config/fish/config.fish"          ".config/fish/config.fish"
link_file "config/fish/conf.d/00-env.fish"   ".config/fish/conf.d/00-env.fish"
link_file "config/fish/conf.d/10-aliases.fish" ".config/fish/conf.d/10-aliases.fish"
link_file "config/fish/conf.d/20-prompt.fish"  ".config/fish/conf.d/20-prompt.fish"
link_file "config/fish/conf.d/30-startup.fish" ".config/fish/conf.d/30-startup.fish"
for fn in "$REPO_DIR"/config/fish/functions/*.fish; do
    link_file "config/fish/functions/$(basename -- "$fn")" ".config/fish/functions/$(basename -- "$fn")"
done
# A pre-existing, unmanaged functions/fish_greeting.fish would run alongside
# conf.d/30-startup.fish and print the greeting twice — back it up and step
# aside (restore it from the backup dir if you prefer your own greeting).
GREET="$HOME/.config/fish/functions/fish_greeting.fish"
if [ -f "$GREET" ] && [ ! -L "$GREET" ]; then
    do_backup "$GREET"
    if dry "remove conflicting $GREET (backed up)"; then :; else
        rm -f -- "$GREET"
        log "removed conflicting $GREET (backed up)"
    fi
fi
link_file "config/yazi/yazi.toml"   ".config/yazi/yazi.toml"
link_file "config/yazi/keymap.toml" ".config/yazi/keymap.toml"
link_file "config/waybar/config.jsonc" ".config/waybar/config.jsonc"
link_file "config/waybar/style.css"    ".config/waybar/style.css"
link_file "config/swaync/config.json"  ".config/swaync/config.json"
link_file "config/swaync/style.css"    ".config/swaync/style.css"
link_file "config/fastfetch/config.jsonc"     ".config/fastfetch/config.jsonc"
link_file "config/fastfetch/nothing-logo.txt" ".config/fastfetch/nothing-logo.txt"

# fuzzel.ini is COPIED (theme-switcher rewrites its color block in place).
copy_file "config/fuzzel/fuzzel.ini" ".config/fuzzel/fuzzel.ini"

# ── 8. Theme files (copies — managed by theme-switcher) ──────────────────
copy_file "themes/$THEME/hypr-theme.conf"  ".config/hypr/nothing-theme.conf"
copy_file "themes/$THEME/kitty-theme.conf" ".config/kitty/nothing-theme.conf"
copy_file "themes/$THEME/waybar-theme.css" ".config/waybar/nothing-theme.css"
copy_file "themes/$THEME/swaync-theme.css" ".config/swaync/nothing-theme.css"
copy_file "themes/$THEME/fish-theme.fish"  ".config/fish/nothing-theme.fish"
copy_file "themes/$THEME/yazi-theme.toml"  ".config/yazi/theme.toml"
case "$THEME" in
    amoled-black) WALLPAPER="nothing-black.png" ;;
    pure-white)   WALLPAPER="nothing-white.png" ;;
esac
copy_file "assets/wallpapers/$WALLPAPER" ".config/hypr/nothing-wallpaper.png"
if [ "$DRY_RUN" -eq 0 ]; then
    # Apply the fuzzel color block from the chosen theme.
    tmp="$(mktemp)"
    awk -v block="$REPO_DIR/themes/$THEME/fuzzel-colors.ini" '
        /^# NOTHING-THEME-BEGIN/ {
            while ((getline line < block) > 0) print line
            close(block); skip = 1; next
        }
        /^# NOTHING-THEME-END/ { skip = 0; next }
        skip == 1 { next }
        { print }
    ' "$HOME/.config/fuzzel/fuzzel.ini" > "$tmp"
    mv "$tmp" "$HOME/.config/fuzzel/fuzzel.ini"
    mkdir -p "$(dirname -- "${XDG_STATE_HOME:-$HOME/.local/state}/nothing/theme")"
    printf '%s\n' "$THEME" > "${XDG_STATE_HOME:-$HOME/.local/state}/nothing/theme"
    log "fuzzel colors applied from $THEME"
else
    log "dry-run: would apply fuzzel colors from $THEME"
fi

# ── 9. Helpers into ~/.local/bin (never overwrite blindly) ───────────────
if [ -e "$HOME/.local/bin/miniland" ] && [ ! -L "$HOME/.local/bin/miniland" ]; then
    log "keeping existing ~/.local/bin/miniland (vendored copy in scripts/ is identical)"
else
    link_file "scripts/miniland" ".local/bin/miniland"
fi
link_file "scripts/theme-switcher" ".local/bin/nothing-theme-switch"
link_file "scripts/nothing-weather" ".local/bin/nothing-weather"

# ── 10. Done ─────────────────────────────────────────────────────────────
# Drop the backup dir when nothing needed backing up (keeps "newest backup"
# meaningful for uninstall.sh).
if [ "$DRY_RUN" -eq 0 ]; then
    rmdir "$BACKUP_DIR" 2>/dev/null || true
fi
if [ -d "$BACKUP_DIR" ]; then
    BACKUP_MSG="$BACKUP_DIR  (restore: ./uninstall.sh)"
else
    BACKUP_MSG="(none needed — no existing configs were replaced)"
fi
log "installed with theme: $THEME"
if [ "$DRY_RUN" -eq 1 ]; then
    log "dry run complete — nothing was changed"
    exit 0
fi
cat <<EOF
install: done.
  theme ......... $THEME  (switch later: nothing-theme-switch)
  backups ....... $BACKUP_MSG
  shell ......... configs installed; to make fish your login shell, run:
                    chsh -s /usr/bin/fish
                  (manual step — the installer never changes it for you)
  fonts ......... run ./assets/fonts/install-fonts.sh for Doto (dot-matrix)
  session ....... log out and pick the Hyprland session, or 'hyprctl reload'
                  if you are already in one. Nothing was restarted for you.
EOF
