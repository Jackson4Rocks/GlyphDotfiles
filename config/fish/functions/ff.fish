# ff — fastfetch shorthand honoring NOTHING_FF
function ff --description "Run fastfetch"
    command -q fastfetch; or return 1
    fastfetch $argv
end
