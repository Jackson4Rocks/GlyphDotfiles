# NOTHING dotfiles — aliases & abbreviations (conf.d/10-aliases.fish)
# Aliases must exist even where eza/bat are missing: guard everything.

if status is-interactive
    # ── ls ────────────────────────────────────────────────────────────────
    if command -q eza
        alias ls='eza --icons --group-directories-first -1'
        alias ll='eza --icons --group-directories-first -l --git'
        alias la='eza --icons --group-directories-first -la'
        alias tree='eza --tree --icons'
    else
        alias ll='ls -l'
        alias la='ls -A'
    end

    # ── cat / grep ────────────────────────────────────────────────────────
    if command -q bat
        alias cat='bat --plain'
    end
    alias grep='grep --color=auto'

    # ── Safety nets ───────────────────────────────────────────────────────
    alias rm='rm -i'
    alias mv='mv -i'
    alias cp='cp -i'

    # ── Navigation ────────────────────────────────────────────────────────
    abbr -a .. 'cd ..'
    abbr -a ... 'cd ../..'
    abbr -a .... 'cd ../../..'
    abbr -a h 'cd ~'
    abbr -a c clear
    abbr -a q exit
    abbr -a mkd 'mkdir -p'

    # ── Git ───────────────────────────────────────────────────────────────
    abbr -a g git
    abbr -a gs 'git status'
    abbr -a gd 'git diff'
    abbr -a ga 'git add .'
    abbr -a gc 'git commit -am'
    abbr -a gl 'git log --oneline -15'
    abbr -a gp 'git push'
    abbr -a gpl 'git pull'
    abbr -a gsw 'git switch'
    abbr -a gsm 'git switch main'
    abbr -a gb 'git branch'
    abbr -a gco 'git checkout'
    abbr -a gst 'git stash'
    abbr -a gsp 'git stash pop'
    abbr -a lg lazygit

    # ── Dotfiles ──────────────────────────────────────────────────────────
    abbr -a theme 'nothing-theme-switch'
    abbr -a ff fastfetch
    abbr -a y yazi

    # ── Tool shims (silent when the tool is absent) ───────────────────────
    if command -q zoxide
        zoxide init fish --cmd cd | source
    end
    if command -q direnv
        direnv hook fish | source
    end
    if command -q fzf
        fzf --fish | source 2>/dev/null
    end
end
