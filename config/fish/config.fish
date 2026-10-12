# NOTHING dotfiles — fish entry point (valid fish syntax only)
# Theme colors live in nothing-theme.fish (managed by install.sh /
# scripts/theme-switcher).
#
# NOTE: fish sources conf.d/*.fish automatically — do NOT source them here
# (double-sourcing used to run startup hooks twice).

source $__fish_config_dir/nothing-theme.fish 2>/dev/null
