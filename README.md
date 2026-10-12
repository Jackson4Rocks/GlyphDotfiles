# NOTHING Dotfiles — Glyph Edition

A complete, monochrome, Nothing OS-inspired desktop for **Arch / CachyOS +
Hyprland (Wayland)**. One design language from the boot wallpaper to the
shell prompt: dot-matrix display type, pill/capsule widgets, thin rules,
flat black-or-white surfaces. Recognizable even in grayscale — no gradients,
no glassmorphism, no neon.

Two first-class themes, chosen at install time, switchable later:

| # | Theme | Background | Foreground |
|---|-------|-----------|------------|
| 1 | **AMOLED BLACK** | pure `#000000` | `#FFFFFF` |
| 2 | **PURE WHITE** | pure `#FFFFFF` | `#000000` |

Same typography, shapes, layouts and keybinds in both. Only color tokens differ.

```
nothing-dotfiles/
├── README.md
├── install.sh                 # safe installer (backup → symlink → theme)
├── uninstall.sh               # restores the newest backup
├── config/                    # static configs (deployed as symlinks)
│   ├── fish/  hypr/  kitty/  yazi/  fastfetch/  noctalia/
│   ├── waybar/  fuzzel/  swaync/    # fallback shell, not autostarted
├── themes/                    # per-theme fragments (deployed as copies)
│   ├── amoled-black/  pure-white/    # tokens.sh + 7 app fragments each
├── scripts/
│   ├── miniland               # vendored minimize/picker/shelf helper
│   ├── theme-switcher         # installed as ~/.local/bin/nothing-theme-switch
│   └── check-configs          # repo validator (runs before install)
└── assets/
    ├── wallpapers/            # generated dot-grid PNGs + generator
    └── fonts/                 # Doto installer (dot-matrix display font)
```

## Design language

- **Typography.** Display/headings/clock: dot-matrix (**NDot 55** if you own
  it — set it in `kitty.conf`/`waybar/style.css`; otherwise **Doto**, fetched
  by `assets/fonts/install-fonts.sh`). Body/terminal: JetBrainsMono Nerd
  Font → monospace fallback. Decorative font is never forced into
  legibility-critical text.
- **Shapes.** Pill bar and modules, capsule workspace indicator, rectangular
  panels with 12–16 px rounding, 1–2 px monochrome borders, dot-grid
  wallpaper with a thin glyph ring.
- **Motion.** One shared `nothing` bezier, slide/pop only, speed 4 — restrained.
- **Icons.** Monochrome text glyphs (`● ○ ◈ ❯ ⏻`), no emoji, no color coding
  except a single danger red (`#FF5252` / `#D92626`) for errors/urgent.

## Supported environment

- OS: Arch Linux, CachyOS (other Arch-likes work with `--force-os`).
- Session: Hyprland on Wayland. KDE Plasma or other WMs are **not replaced**;
  these configs only activate inside a Hyprland session.
- Shell: Fish. Terminal: Kitty. Files: Yazi. Sysinfo: Fastfetch.
- **Base desktop shell: Noctalia v5** (bar, launcher, notifications,
  control center, session menu, lockscreen, wallpaper — see below).
  Waybar + Fuzzel + SwayNC configs ship as a documented fallback but are
  not autostarted: one bar, one notification daemon at a time.
- Helpers reused where needed: grim/slurp, cliphist,
  eza/zoxide/fzf/bat (all optional with graceful fallbacks).

### Noctalia v5 is the base shell

Noctalia owns the bar, app launcher, notifications, control center,
clipboard history, session menu, lockscreen and wallpaper — all styled
Nothing-monochrome via `config/noctalia/config.toml` and the single
`palettes/NothingMono.json` (its `dark` section is AMOLED BLACK, its
`light` section PURE WHITE; `nothing-theme-switch` flips only the mode,
so GUI tweaks survive switching).

- Bar: floating capsule, launcher + workspaces + window left, Doto 12-hour
  clock center, media/network/volume/battery/tray/notifications right.
- Lockscreen (`SUPER+CTRL+L`): blurred desktop, tint, fade+zoom
  transitions, big centered Doto 12-hour clock. No hyprlock needed —
  a second locker would only compete with it.
- Notifications: Noctalia daemon only. SwayNC/Dunst stay off.
- Waybar/Fuzzel/SwayNC configs remain in the repo as a fallback shell
  ( brighter `@fg` segments included); start them manually and quit
  Noctalia if you ever want to compare. Never run both bars at once.

## Installation

```sh
cd nothing-dotfiles
./scripts/check-configs        # optional but recommended
./install.sh --dry-run         # preview everything, change nothing
./install.sh                   # real install: backup → link → theme menu
```

You will see:

```
1. AMOLED BLACK — Pure black, white text
2. PURE WHITE — Pure white, black text
```

Enter `1` or `2`. The choice is echoed back and applied to Hyprland, Kitty,
Fish, Waybar, SwayNC, Fuzzel, Yazi and the wallpaper. Non-interactive:

```sh
./install.sh --theme amoled-black
```

What the installer does and does **not** do:

- Backs up every touched file to `~/.config_backup/nothing/<timestamp>/`.
- Symlinks static configs, copies theme fragments. Re-running is idempotent.
- Never uses sudo (unless you pass `--install-deps`), never changes your
  login shell, never touches boot/security/display-manager files, never
  restarts your session.
- `~/.config/hypr/monitors.conf` is only created when you have none.
- Your existing `~/.local/bin/miniland` is kept (the repo's copy is identical).

After installing:

```sh
./assets/fonts/install-fonts.sh   # Doto dot-matrix font (per-user, no sudo)
chsh -s /usr/bin/fish             # optional, manual: make fish the login shell
hyprctl reload                    # or log out/in to the Hyprland session
```

## Switching themes later

```sh
nothing-theme-switch              # interactive menu
nothing-theme-switch pure-white   # direct
```

Switching rewrites only the managed theme fragments + wallpaper and
live-reloads Hyprland/Kitty/SwayNC/Waybar. Nothing else is touched.

## Keybind reference (`$mainMod` = SUPER)

★ = confirmed historical binding (Miniland setup — preserved verbatim).
[NEW] = fresh default; no other historical bindings were found in the repo
or context, so nothing else below is claimed as “previously agreed”. If you
have an older keybind map, open an issue and they will be reconciled.

| Shortcut | Action |
|---|---|
| ★ `SUPER + M` | Minimize active window (moves to hidden shelf, remembers origin; never closes/kills) |
| ★ `SUPER + SHIFT + N` | Open the Miniland picker (restore minimized windows) |
| ★ `SUPER + ALT + M` | Toggle the Miniland shelf (show/hide minimized windows) |
| [NEW] `SUPER + RETURN` | Terminal (kitty) |
| [NEW] `SUPER + E` | File manager (yazi in kitty) |
| [NEW] `SUPER + B` | Browser (xdg-open) |
| [NEW] `SUPER + D` | App launcher (Noctalia) |
| [NEW] `SUPER + SPACE` | App picker, large panel (fuzzel, fallback) |
| [NEW] `SUPER + S` / `SUPER + V` / `SUPER + W` | Control center / clipboard history / wallpaper (Noctalia) |
| [NEW] `SUPER + COMMA` | Noctalia settings |
| [NEW] `SUPER + Q` | Close window (graceful) |
| [NEW] `SUPER + F` / `SUPER + SHIFT + F` | Fullscreen / maximize |
| [NEW] `SUPER + SHIFT + SPACE` | Toggle floating |
| [NEW] `SUPER + P` / `SUPER + O` | Pseudotile / togglesplit |
| [NEW] `SUPER + SHIFT + Q` | Exit Hyprland |
| [NEW] `SUPER + ←→↑↓` / `H L K J` | Focus |
| [NEW] `SUPER + TAB` | Cycle windows |
| [NEW] `SUPER + SHIFT + ←→↑↓` / `H L K J` | Move window |
| [NEW] `SUPER + 1..9,0` | Workspaces 1–10 |
| [NEW] `SUPER + SHIFT + 1..9,0` | Move window to workspace |
| [NEW] `SUPER + S` / `SUPER + SHIFT + S` | Scratchpad toggle / send |
| [NEW] `SUPER + N` / `SUPER + SHIFT + D` | Notification panel / do-not-disturb (Noctalia) |
| [NEW] `PRINT` / `SUPER + PRINT` | Region / fullscreen screenshot (Noctalia) |
| [NEW] `SUPER + X` / `SUPER + CTRL + L` | Session menu / lock with animated lockscreen (Noctalia) |
| [NEW] `SUPER + CTRL + T` | Theme switcher |
| `SUPER + drag / right-drag` | Move / resize window |
| Media/brightness keys | Noctalia volume/brightness/media IPC |

Minimize semantics: `SUPER+M` on a normal window shelves it to
`special:miniland`; `SUPER+M` on a shelf window (or picking it with
`SUPER+SHIFT+N`) restores it to its origin workspace. CLI:
`miniland minimize|picker|restore-last|restore N|restore-all|list|toggle-shelf`.

## Fish shell

- Prompt (`conf.d/20-prompt.fish`): `●` status capsule, compact `…/` path,
  `◈ branch` git dot (`*` when dirty, red), `❯` marker, muted `HH:MM` right
  prompt. Builtins only — fast even in huge repos (one `git branch` call;
  `git diff --quiet` runs only inside repos).
- `conf.d/00-env.fish`: editor/pager, 50k shared deduplicated history, no
  greeting, passive `~/.local/bin` PATH only.
- `conf.d/10-aliases.fish`: eza/bat-aware `ls`/`cat` with plain fallbacks,
  `-i` safety nets, `..`/`...`/`mkd` abbreviations, git shorthand,
  `theme`/`ff`/`y` abbreviations, zoxide/direnv/fzf hooks only if installed.
- `conf.d/30-startup.fish`: fastfetch on interactive shells (skipped over
  SSH/in yazi/deep nesting; `NOTHING_FF=0` mutes, `=1` forces). A
  per-process sentinel guarantees it runs at most once per shell, and
  `config.fish` never re-sources `conf.d/` (fish does that itself —
  double-sourcing used to print the greeting twice). The installer also
  backs aside a pre-existing unmanaged `functions/fish_greeting.fish`,
  which was a third greeting source.
- `functions/`: `up N`, `mkcd`, `extract`, `ff`. All valid fish, checked by
  `fish -n` in CI and `scripts/check-configs`.

## Backup, uninstall, recovery

- Every install snapshots to `~/.config_backup/nothing/<timestamp>/`.
- `./uninstall.sh` removes created symlinks and restores the newest backup
  (`--backup NAME` picks an older one; `--dry-run` previews).
- If your session ever looks wrong: `hyprctl reload`, open a new fish
  terminal, or log out/in. As a last resort, restore manually:
  `cp -a ~/.config_backup/nothing/<stamp>/.config ~/`.

## Known limitations / manual steps

- NDot 55 is proprietary and cannot be fetched or bundled; Doto (OFL) is the
  automatic pick. Set NDot 55 manually if you have it licensed.
- Login shell is never changed automatically (`chsh -s /usr/bin/fish`).
- No session is started or restarted for you.
- `SUPER+B` uses `xdg-open` (no browser assumed); edit `$browser` in
  `config/hypr/keybinds.conf` if you want a fixed one.
- Hyprland 0.56 loads `hyprland.lua` instead of `hyprland.conf` when both
  exist (seen in the compositor log). The installer backs any stale `.lua`
  aside so the classic config — and all keybinds — actually load. After a
  fresh install you must LOG OUT and back in once; `hyprctl reload` alone
  keeps the old config source.
- Full historical keybind parity beyond the three ★ bindings is unverified —
  the remaining map is documented as new (see table).
- Hyprland configs are validated with the native `hyprland --verify-config`
  (headless, in an isolated HOME) via `scripts/check-configs`, for both
  themes. Waybar/SwayNC live-reload paths are exercised only in a real
  session.
