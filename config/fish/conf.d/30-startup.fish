# NOTHING dotfiles — startup (conf.d/30-startup.fish)
# Fastfetch runs AT MOST once per shell process (sentinel), on interactive
# shells only; skipped inside yazi, over dumb terminals, and in deep nests.
# Set NOTHING_FF=0 to mute, =1 to force.

if status is-interactive; and not set -q __nothing_greeted
    set -g __nothing_greeted 1
    if command -q fastfetch
        if test "$NOTHING_FF" = 1
            fastfetch
        else if test "$NOTHING_FF" != 0; and test "$TERM" != dumb; and test -z "$YAZI_LEVEL"; and test "$SHLVL" -le 3
            fastfetch
        end
    end
end
