# NOTHING dotfiles — fish entry point (valid fish syntax only)
# Theme colors live in nothing-theme.fish (managed by install.sh /
# scripts/theme-switcher). Per-topic config lives in conf.d/.

# Theme first so prompt and plugins see the tokens.
source $__fish_config_dir/nothing-theme.fish 2>/dev/null

for f in $__fish_config_dir/conf.d/*.fish
    source $f 2>/dev/null
end
