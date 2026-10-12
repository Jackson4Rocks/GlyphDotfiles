# NOTHING dotfiles — prompt (conf.d/20-prompt.fish)
# Glyph-bar prompt: a two-glyph status capsule + compact path + git dot.
# Pure fish builtins only; theme tokens come from nothing-theme.fish.

function fish_prompt
    set -l last_status $status

    set -l fg $NOTHING_FG
    set -l muted $NOTHING_MUTED
    set -l accent $NOTHING_ACCENT
    test -z "$fg"; and set fg ffffff
    test -z "$muted"; and set muted a3a3a3
    test -z "$accent"; and set accent $fg

    # Status glyph: ● white on success, ○ danger on failure.
    if test $last_status -eq 0
        printf '%s%s%s ' (set_color $accent) "●" (set_color normal)
    else
        printf '%s%s %s%s ' (set_color $NOTHING_DANGER) "○" $last_status (set_color normal)
    end

    # Compact path: ~-contracted, max 2 segments + head ellipsis.
    set -l pwd_home (string replace -r "^$HOME" "~" $PWD)
    set -l segs (string split / $pwd_home)
    set -l shown $pwd_home
    if test (count $segs) -gt 3
        set shown "…/"(string join / $segs[-2..-1])
    end
    printf '%s%s%s ' (set_color $muted) $shown (set_color normal)

    # Git dot: branch name when inside a repo, silent otherwise.
    set -l branch (git branch --show-current 2>/dev/null)
    if test -n "$branch"
        if git diff --quiet 2>/dev/null
            printf '%s%s%s ' (set_color $accent) "◈ $branch" (set_color normal)
        else
            printf '%s%s%s ' (set_color $NOTHING_DANGER) "◈ $branch*" (set_color normal)
        end
    end

    printf '%s❯%s ' (set_color $fg) (set_color normal)
end

function fish_right_prompt
    # Clock capsule, muted. Keep it cheap: one date call.
    printf '%s%s%s' (set_color $NOTHING_MUTED) (date +%H:%M) (set_color normal)
end

function fish_mode_prompt
    # Vi-mode indicator stays empty — the glyph prompt owns the left edge.
end
