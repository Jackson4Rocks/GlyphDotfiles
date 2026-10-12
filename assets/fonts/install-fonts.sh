#!/bin/sh
# install-fonts.sh — fetch the dot-matrix display font (Doto, OFL-licensed).
# NDot 55 is proprietary to Nothing and cannot be redistributed, so Doto is
# the bundled pick; every config falls back to JetBrainsMono/monospace when
# no dot-matrix font is present. Never needs sudo: installs to ~/.fonts.
set -eu

FONT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/fonts/NothingDot"

log() { printf '%s\n' "fonts: $*"; }

if fc-list 2>/dev/null | grep -qiE 'doto|ndot'; then
    log "a dot-matrix font (Doto/NDot) is already installed — nothing to do."
    fc-list | grep -iE 'doto|ndot' | head -5
    exit 0
fi

command -v curl >/dev/null 2>&1 || { echo "fonts: curl is required." >&2; exit 1; }

mkdir -p "$FONT_DIR"
fetched=0

# Doto ships as a variable font upstream; try known locations in order,
# then static weights as a last resort.
CANDIDATES="https://raw.githubusercontent.com/google/fonts/main/ofl/doto/Doto%5BROND%2Cwght%5D.ttf
https://github.com/google/fonts/raw/main/ofl/doto/Doto%5BROND%2Cwght%5D.ttf
https://github.com/google/fonts/raw/main/ofl/doto/Doto%5Bwght%5D.ttf"
for url in $CANDIDATES; do
    if curl -fL --retry 2 -o "$FONT_DIR/Doto-Variable.ttf" "$url" 2>/dev/null; then
        if [ "$(stat -c %s "$FONT_DIR/Doto-Variable.ttf" 2>/dev/null || echo 0)" -gt 50000 ]; then
            log "fetched Doto-Variable.ttf"
            fetched=1
            break
        fi
    fi
    rm -f "$FONT_DIR/Doto-Variable.ttf"
done
if [ "$fetched" -eq 0 ]; then
    for w in Regular Medium SemiBold Bold ExtraBold Black; do
        f="Doto-${w}.ttf"
        if curl -fL --retry 2 -o "$FONT_DIR/$f" "$URL_BASE/$f" 2>/dev/null; then
            log "fetched $f"
            fetched=1
        else
            rm -f "$FONT_DIR/$f"
        fi
    done
fi

if [ "$fetched" -eq 0 ]; then
    echo "fonts: download failed (no network?). Configs keep working with" >&2
    echo "fonts: the JetBrainsMono/monospace fallback until you retry." >&2
    exit 1
fi

if command -v fc-cache >/dev/null 2>&1; then
    fc-cache -f "$FONT_DIR" >/dev/null 2>&1 || true
fi
if fc-list 2>/dev/null | grep -qi 'doto'; then
    log "verified: $(fc-list | grep -oi 'doto[^:]*' | head -1)"
else
    log "installed to $FONT_DIR (run fc-cache -f and restart apps if it is not picked up)"
fi
