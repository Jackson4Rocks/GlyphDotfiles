# 🌑 GLYPH DOTFILES

A Nothing OS-inspired desktop for Arch Linux and Hyprland.

Hyprland · Fish · Kitty · Noctalia

✨ Minimal. Monochrome. Customizable.

Bring the Nothing-inspired aesthetic to your Linux desktop with dot-matrix typography, capsule-shaped widgets, clean layouts, minimal borders, and two beautiful high-contrast themes.

Choose between AMOLED Black and Pure White during installation, and switch between them whenever you want.

## ✨ What is this?

Glyph Dotfiles is a complete desktop configuration designed around the visual identity of Nothing OS.

The goal is simple: make your Linux desktop feel cohesive, minimal, and functional without unnecessary visual clutter.

🌑 AMOLED Black — Pure black backgrounds with white text.

☀️ Pure White — Pure white backgrounds with black text.

🎨 Consistent design — Matching wallpapers, typography, terminal, shell prompt, widgets, and system controls.

🛠️ Useful tools — Hyprland, Noctalia, Fish, Kitty, Yazi, Fastfetch, and Miniland.

🔒 Safer installation — Backups before changes, a dry-run option, and an uninstall script for recovery.

No unnecessary gradients, neon, or glass effects. Just clean monochrome styling inspired by Nothing.

## 🖥️ At a glance

| Component   | Purpose                                                                 |
| ----------- | ----------------------------------------------------------------------- |
| Hyprland    | Wayland desktop and window management                                   |
| Noctalia v5 | Bar, launcher, notifications, control center, lockscreen, and wallpaper |
| Fish        | Shell with a custom prompt and useful shortcuts                         |
| Kitty       | Terminal emulator                                                       |
| Yazi        | Terminal-based file manager                                             |
| Fastfetch   | System information                                                      |
| Miniland    | Minimize windows to a shelf and restore them later                      |
| Doto        | Dot-matrix display font                                                 |

Supported environment: Arch Linux running Hyprland on Wayland. Other Arch-based distributions may work with `--force-os`.

Your existing KDE Plasma installation or other desktop environment is not intentionally replaced. These configurations are intended for Hyprland sessions.

## 🎨 Choose your theme

Two themes. One design. Your choice.

### 🌑 AMOLED BLACK

Pure `#000000` backgrounds with `#FFFFFF` foregrounds.

Perfect for a completely black desktop with crisp, monochrome details.

### ☀️ PURE WHITE

Pure `#FFFFFF` backgrounds with `#000000` foregrounds.

A bright, minimal desktop with the same Nothing-inspired layout.

| Setting    | AMOLED Black   | Pure White   |
| ---------- | -------------- | ------------ |
| Background | `#000000`      | `#FFFFFF`    |
| Foreground | `#FFFFFF`      | `#000000`    |
| Theme name | `amoled-black` | `pure-white` |

Both themes use the same typography, layouts, shapes, animations, and keyboard shortcuts. Only the color palette and matching wallpaper change.

You can choose a theme during installation or switch later without reinstalling everything.

## 🚀 Quick installation

Ready to get started? Follow these steps in order.

### 1. 📥 Open the repository

Clone the repository if you haven't already, then enter its directory.

```
git clone https://github.com/Jackson4Rocks/nothing-dotfiles.git
cd nothing-dotfiles
```

### 2. ✅ Check the configurations

Run the configuration checker before installing.

```
./scripts/check-configs
```

This checks supported configuration files and validates the Hyprland configurations for both themes.

### 3. 🔍 Preview the changes

Before making changes to your desktop, run:

```
./install.sh --dry-run
```

This previews the installation without applying it.

### 4. ⚙️ Install

Start the installer:

```
./install.sh
```

Choose your preferred theme when prompted:

1 — AMOLED BLACK 🌑

2 — PURE WHITE ☀️

Enter `1` or `2` and follow the on-screen instructions.

### Prefer choosing a theme directly?

Skip the interactive theme selection:

```
./install.sh --theme amoled-black
```

Or install the white theme:

```
./install.sh --theme pure-white
```

### 5. 🔤 Install the font

After installation, install the Doto dot-matrix font for your user:

```
./assets/fonts/install-fonts.sh
```

### 6. 🔄 Reload your desktop

```
hyprctl reload
```

Important: On a fresh Hyprland 0.56 installation, log out of Hyprland and log back in once. A regular reload might continue using the previous configuration source.

That's it! Enjoy your new desktop. ✨

## 🛡️ What does the installer actually do?

The installer is designed to avoid unnecessarily disturbing your existing setup.

Before making changes:

- 📦 Backs up affected files to `~/.config_backup/nothing/<timestamp>/`.
- 🔗 Creates symlinks for static configurations.
- 🎨 Copies the selected theme fragments into place.
- 🔁 Supports repeat installations without continually duplicating its changes.
- 🖥️ Creates `~/.config/hypr/monitors.conf` only if you do not already have one.

What it deliberately avoids:

- It does not use `sudo` unless you explicitly pass `--install-deps`.
- It does not automatically change your login shell.
- It does not modify boot, security, or display-manager files.
- It does not automatically restart your desktop session.
- It preserves an existing `~/.local/bin/miniland` because the repository version is identical.

The installer also moves aside a stale `hyprland.lua` when necessary. Hyprland 0.56 can load that file instead of `hyprland.conf`, which may prevent the expected settings and keyboard shortcuts from taking effect.

A quick reminder: Backups make recovery easier, but you should still inspect the dry-run output and keep important personal configurations backed up.

## 🌌 Your new desktop

### 🪟 Noctalia — The heart of the desktop

Noctalia v5 handles the main desktop shell experience.

It manages the bar, application launcher, notifications, control center, clipboard history, session menu, lockscreen, and wallpaper.

Everything follows the same Nothing-inspired monochrome design.

The bar

A floating capsule layout with:

- Application launcher and workspaces on the left.
- A centered 12-hour Doto clock.
- Media, network, volume, battery, tray, and notifications on the right.

The lockscreen

Use `SUPER + CTRL + L` for the animated Noctalia lockscreen, featuring a large centered clock, background tint, and transitions.

No additional hyprlock configuration is intended to compete with this setup.

Notifications

Noctalia is the active notification daemon. SwayNC and Dunst are not started alongside it by default.

Control center

Access system controls using the configured keyboard shortcut or Noctalia's interface.

### 🔤 Typography

The desktop uses a combination of distinctive display typography and readable monospace text.

- Doto: The included dot-matrix display font.
- NDot 55: An optional proprietary font for users who already have a license.
- JetBrainsMono Nerd Font: Preferred for body and terminal text, with a monospace fallback.

Decorative fonts are not forced onto text where readability matters.

### ◻️ Shapes and animations

Expect capsule-shaped widgets, compact workspace indicators, thin monochrome borders, and panels with modest rounding.

Animations use restrained slide and pop effects rather than flashy transitions.

Icons stay monochrome, with red reserved for urgent or error states.

### 🖼️ Wallpapers

The wallpapers are prepared for 1920 × 1080 center crops without synthetic fill.

- 🌑 AMOLED BLACK: Dark, perforated-phone artwork.
- ☀️ PURE WHITE: Grey-leaf artwork.
- 🔒 Lockscreen: A separate dark geometric background.

The wallpaper and color palette follow the selected theme.

### 🔁 Optional fallback shell

The repository also includes configurations for Waybar, Fuzzel, and SwayNC.

These are optional alternatives, not additional components that start automatically.

If you decide to try them, stop the corresponding Noctalia components first. Running two bars or notification daemons simultaneously can lead to overlapping interfaces and duplicate notifications.

## ⌨️ Keyboard shortcuts

The following shortcuts are configured for this setup.

`SUPER` means your Windows or Meta key.

The three Miniland shortcuts marked ⭐ are the original bindings preserved from the existing setup. Other shortcuts are defaults introduced by this configuration and may differ from your previous Hyprland setup.

### 🪟 Window management

| Shortcut                     | Action                                           |
| ---------------------------- | ------------------------------------------------ |
| `SUPER + M` ⭐                | Minimize the active window to the Miniland shelf |
| `SUPER + SHIFT + N` ⭐        | Open the Miniland picker                         |
| `SUPER + ALT + M` ⭐          | Show or hide the Miniland shelf                  |
| `SUPER + Q`                  | Close the active window                          |
| `SUPER + F`                  | Toggle fullscreen                                |
| `SUPER + SHIFT + F`          | Maximize the window                              |
| `SUPER + SHIFT + SPACE`      | Toggle floating mode                             |
| `SUPER + P`                  | Toggle pseudotile                                |
| `SUPER + O`                  | Toggle split direction                           |
| `SUPER + TAB`                | Cycle through windows                            |
| `SUPER + Arrow Keys`         | Move focus between windows                       |
| `SUPER + SHIFT + Arrow Keys` | Move the active window                           |
| `SUPER + Drag`               | Move a window using the mouse                    |
| `SUPER + Right-Drag`         | Resize a window using the mouse                  |
| `SUPER + SHIFT + Q`          | Exit Hyprland                                    |

### 🚀 Applications and desktop controls

| Shortcut            | Action                                 |
| ------------------- | -------------------------------------- |
| `SUPER + ENTER`     | Open Kitty terminal                    |
| `SUPER + E`         | Open Dolphin file manager              |
| `SUPER + B`         | Open the default browser               |
| `SUPER + D`         | Open the Noctalia application launcher |
| `SUPER + SPACE`     | Open the Noctalia application launcher |
| `SUPER + S`         | Open the Noctalia control center       |
| `SUPER + V`         | Open clipboard history                 |
| `SUPER + W`         | Open wallpaper controls                |
| `SUPER + COMMA`     | Open Noctalia settings                 |
| `SUPER + N`         | Open the notification panel            |
| `SUPER + SHIFT + D` | Toggle Do Not Disturb                  |
| `SUPER + X`         | Open the session menu                  |
| `SUPER + L`         | Lock the screen                        |
| `SUPER + CTRL + L`  | Open the animated Noctalia lockscreen  |
| `SUPER + CTRL + T`  | Open the theme switcher                |
| `PRINT`             | Take a region screenshot               |
| `SUPER + PRINT`     | Take a fullscreen screenshot           |

Dolphin is the graphical file manager, while Yazi remains available for terminal-based file management.

The browser shortcut uses `xdg-open`, so it opens your system's default browser.

### 🧭 Workspaces

| Shortcut                                        | Action                                   |
| ----------------------------------------------- | ---------------------------------------- |
| `SUPER + 1` through `SUPER + 9`                 | Switch to workspaces 1–9                 |
| `SUPER + 0`                                     | Switch to workspace 10                   |
| `SUPER + SHIFT + 1` through `SUPER + SHIFT + 9` | Move the active window to workspaces 1–9 |
| `SUPER + SHIFT + 0`                             | Move the active window to workspace 10   |

### 🔊 Media and brightness

Your keyboard's media and brightness keys are handled through Noctalia's corresponding controls where supported by your hardware.

### ⚠️ Keyboard shortcut note

`SUPER + S` appears in the documented configuration for both the Noctalia control center and a Hyprland scratchpad action.

If both are enabled, they conflict. Check `config/hypr/keybinds.conf` and decide which action you prefer.

The same applies if you customize any other shortcut that is already assigned to a different action.

### 📦 Miniland: minimizing without closing apps

Miniland lets you temporarily hide windows without closing their applications.

When you press `SUPER + M`, the active window moves to the special workspace `special:miniland`. The app remains open.

You can restore it with `SUPER + SHIFT + N`, or show and hide the shelf using `SUPER + ALT + M`.

A restored window returns to its original workspace.

You can also use the command line:

```
miniland minimize
miniland picker
miniland restore-last
miniland restore N
miniland restore-all
miniland list
miniland toggle-shelf
```

## 🐟 Fish shell

The included Fish configuration is designed to be fast, practical, and consistent with the rest of the desktop.

### ✨ Custom prompt

The prompt displays your current status, working directory, Git branch, and whether the repository contains uncommitted changes.

A compact clock appears on the right prompt where supported.

### 🧰 Helpful shortcuts

The configuration includes:

- `..`, `...`, and `mkd` abbreviations for common directory operations.
- Git shorthand for frequent commands.
- `theme` for theme-related actions.
- `ff` for Fastfetch.
- `y` for Yazi.
- `up`, `mkcd`, `extract`, and `ff` helper functions.

### ⚡ Quality-of-life improvements

- Shared, deduplicated history with up to 50,000 entries.
- No unnecessary default greeting.
- Adds `~/.local/bin` to `PATH` without unnecessary side effects.
- Uses `eza` and `bat` for `ls` and `cat` when available, with ordinary-command fallbacks.
- Enables integrations for `zoxide`, `direnv`, and `fzf` only when those tools are installed.

### 🖥️ Fastfetch at startup

Fastfetch runs automatically in interactive shells, with safeguards to avoid unnecessary execution in SSH sessions, inside Yazi, and in deeply nested shells.

Disable it for a shell with:

```
NOTHING_FF=0
```

Force it to run with:

```
NOTHING_FF=1
```

The configuration is designed to avoid repeated greetings and unnecessary re-sourcing.

Fish syntax is checked with `fish -n` by the validation script and in CI.

## 🎨 Change your theme whenever you want

Already installed? Switching themes does not require reinstalling the whole configuration.

Open the theme selection menu:

```
nothing-theme-switch
```

Switch directly to AMOLED Black:

```
nothing-theme-switch amoled-black
```

Switch directly to Pure White:

```
nothing-theme-switch pure-white
```

You can also open the switcher from your desktop using:

`SUPER + CTRL + T`

The switcher updates the managed theme fragments and wallpaper, then live-reloads supported applications. Other unrelated configuration is left alone.

## 🧹 Uninstalling

Want to go back to your previous setup?

Open a terminal in the repository directory and run:

```
./uninstall.sh
```

The uninstall script removes the symlinks it created and restores the newest backup.

### 🔍 Preview before uninstalling

```
./uninstall.sh --dry-run
```

### 📦 Restore an older backup

```
./uninstall.sh --backup NAME
```

Your backups are located in:

`~/.config_backup/nothing/<timestamp>/`

### 🛠️ Something looks wrong?

Try reloading Hyprland:

```
hyprctl reload
```

If the settings still do not appear, open a new terminal or log out of Hyprland and log back in.

A fresh Hyprland 0.56 installation may require logging out and back in before the correct configuration source is loaded.

As a last resort, inspect your backups:

```
ls -lt ~/.config_backup/nothing/
```

Restore only the configuration files you need. Avoid copying an entire backup over your home directory.

## 📁 Repository structure

Here's what you'll find in the project:

- 📄 `README.md` — Project documentation.
- ⚙️ `install.sh` — Installer with backup, configuration linking, and theme selection.
- 🧹 `uninstall.sh` — Removes managed links and restores backups.
- 🐟 `config/fish/` — Fish shell configuration.
- 🪟 `config/hypr/` — Hyprland configuration and keyboard shortcuts.
- 🖥️ `config/kitty/` — Kitty terminal configuration.
- 📂 `config/yazi/` — Yazi file manager configuration.
- 📊 `config/fastfetch/` — Fastfetch appearance and system information.
- 🌌 `config/noctalia/` — Main desktop shell configuration.
- 🔄 `config/waybar/`, `config/fuzzel/`, and `config/swaync/` — Optional fallback components.
- 🎨 `themes/amoled-black/` — AMOLED Black theme fragments.
- ☀️ `themes/pure-white/` — Pure White theme fragments.
- 📦 `scripts/miniland` — Window minimization and restoration helper.
- 🎨 `scripts/theme-switcher` — Installed as `~/.local/bin/nothing-theme-switch`.
- ✅ `scripts/check-configs` — Configuration validation.
- 🖼️ `assets/wallpapers/` — Wallpaper assets and generator.
- 🔤 `assets/fonts/` — Doto font installer and related assets.

## 📝 Important things to know

🔤 NDot 55 is proprietary. It cannot be automatically downloaded or bundled. Doto is the included alternative.

🐟 Changing your login shell is optional. To make Fish your login shell manually, run:

```
chsh -s /usr/bin/fish
```

The installer will not change it for you.

🔄 Your session is not restarted automatically. You may need to log out and back in for certain Hyprland changes to apply.

🌐 The browser shortcut uses your default browser. To choose a specific browser, edit `$browser` in `config/hypr/keybinds.conf`.

⌨️ Not every shortcut is an original binding. Only the three Miniland shortcuts are confirmed as preserved historical shortcuts; other bindings are documented as new defaults.

🔔 Do not run duplicate desktop components. Noctalia is the primary shell. Stop its corresponding components before manually starting the Waybar/Fuzzel/SwayNC fallback setup.

✅ Configuration validation has limits. The checker validates supported Hyprland configuration files for both themes. Some live reload behavior can only be checked in an actual desktop session.

## ⭐ Make it yours

Your desktop should work the way you want it to.

Choose your theme, learn the shortcuts, customize your applications, and adjust the configurations to suit your workflow.

🌑 Stay dark. Stay minimal.

☀️ Or keep it bright.

🌌 Keep it Nothing-inspired. Make it yours.
