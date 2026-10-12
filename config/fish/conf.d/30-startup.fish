# NOTHING dotfiles — startup (conf.d/30-startup.fish)
# Fastfetch on interactive login shells only; skipped inside yazi/kitty
# scrollback restores and over SSH unless asked. Set NOTHING_FF=0 to mute.

if status is-interactive
    if not set -q NOTHING_FF; and command -q fastfetch
        if test "$TERM" != dumb; and test -z "$YAZI_LEVEL"; and test "$SHLVL" -le 3
            fastfetch
        end
    else if test "$NOTHING_FF" = 1; and command -q fastfetch
        fastfetch
    end
end
