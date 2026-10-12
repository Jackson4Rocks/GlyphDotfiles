#!/usr/bin/env python3
"""Generate the two NOTHING monochrome wallpapers (pure stdlib, no deps).

Dot-matrix grid + thin glyph ring on a flat field. Run from anywhere:
    python3 make-wallpapers.py
Writes nothing-black.png / nothing-white.png next to this script.
"""
import math
import struct
import zlib
from pathlib import Path

W, H = 1920, 1080
STEP = 48
DOT_R = 2


def hex_to_rgb(h):
    h = h.lstrip("#")
    return tuple(int(h[i : i + 2], 16) for i in (0, 2, 4))


def render(bg, dot, ring, center):
    bg = hex_to_rgb(bg)
    dot = hex_to_rgb(dot)
    ring = hex_to_rgb(ring)
    center = hex_to_rgb(center)
    cx, cy, radius, thick = W // 2, H // 2, 210, 4
    rows = []
    for y in range(H):
        row = bytearray()
        for x in range(W):
            # dot grid
            gx, gy = x % STEP, y % STEP
            dx, dy = gx - STEP // 2, gy - STEP // 2
            if dx * dx + dy * dy <= DOT_R * DOT_R:
                row += bytes(dot)
                continue
            # glyph ring + center dot
            dist = math.hypot(x - cx, y - cy)
            if abs(dist - radius) <= thick / 2:
                row += bytes(ring)
            elif dist <= 7:
                row += bytes(center)
            else:
                row += bytes(bg)
        rows.append(b"\x00" + bytes(row))
    raw = b"".join(rows)

    def chunk(typ, data):
        c = struct.pack(">I", len(data)) + typ + data
        return c + struct.pack(">I", zlib.crc32(typ + data) & 0xFFFFFFFF)

    png = (
        b"\x89PNG\r\n\x1a\n"
        + chunk(b"IHDR", struct.pack(">IIBBBBB", W, H, 8, 2, 0, 0, 0))
        + chunk(b"IDAT", zlib.compress(raw, 6))
        + chunk(b"IEND", b"")
    )
    return png


OUT = Path(__file__).parent
(OUT / "nothing-black.png").write_bytes(
    render("#000000", "#1c1c1c", "#3a3a3a", "#ffffff")
)
(OUT / "nothing-white.png").write_bytes(
    render("#ffffff", "#e3e3e3", "#b5b5b5", "#000000")
)
print("wrote nothing-black.png nothing-white.png")
