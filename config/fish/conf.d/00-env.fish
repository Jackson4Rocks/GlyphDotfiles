# NOTHING dotfiles — fish environment & options (conf.d/00-env.fish)
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER less
set -gx MANPAGER "less -R"
set -gx BAT_THEME ansi

# History: large, deduplicated, session-shared.
set -g fish_history_max 50000

# No greeting noise; the prompt carries the branding.
set -g fish_greeting ""

# Passive PATH additions only — never touches the login shell.
fish_add_path -p $HOME/.local/bin
fish_add_path -p $HOME/.cargo/bin
fish_add_path -p $HOME/go/bin
