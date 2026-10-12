#!/bin/sh
# install-fonts.sh — fetch the dot-matrix display font (Doto, OFL-licensed).
# NDot 55 is proprietary to Nothing and cannot be redistributed, so Doto is
# the bundled pick; every config falls back to JetBrainsMono/monospace when
# no dot-matrix font is present. Never needs sudo: installs to ~/.fonts.
set -eu

FONT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/fonts/NothingDot"
URL_BASE="https://github.com/google/fonts/raw/main/ofl/doto"

log() { printf '%s\n' "fonts: $*"; }

if fc-list 2>/dev/null | grep -qiE 'doto|ndot'; then
    log "a dot-matrix font (Doto/NDot) is already installed — nothing to do."
    fc-list | grep -iE 'doto|ndot' | head -5
    exit 0
fi

command -v curl >/dev/null 2>&1 || { echo "fonts: curl is required." >&2; exit 1; }

mkdir -p "$FONT_DIR"
ok=0
for w in Regular Medium SemiBold Bold ExtraBold Black; do
    f="Doto-${w}.ttf"
    if curl -fL --retry 2 -o "$FONT_DIR/$f" "$URL_BASE/$f" 2>/dev/null; then
        log "fetched $f"
        ok=1
    else
        log "WARNING: could not fetch $f (offline?) — continuing"
        rm -f "$FONT_DIR/$f"
    fi
done

if [ "$ok" -eq 0 ]; then
    echo "fonts: download failed (no network?). Configs keep working with" >&2
    echo "fonts: the JetBrainsMono/monospace fallback until you retry." >&2
    exit 1
fi

if command -v fc-cache >/dev/null 2>&1; then
    fc-cache -f "$FONT_DIR" >/dev/null 2>&1 || true
fi
log "installed to $FONT_DIR"
