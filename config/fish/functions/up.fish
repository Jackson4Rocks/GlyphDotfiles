# up — go up N directories (default 1)
function up --description "Go up N directories"
    set -l n 1
    if test (count $argv) -ge 1
        set n $argv[1]
    end
    if not string match -qr '^[0-9]+$' $n
        echo "up: expected a number, got '$n'" >&2
        return 1
    end
    set -l target ""
    for i in (seq $n)
        set target "$target../"
    end
    cd $target
end
