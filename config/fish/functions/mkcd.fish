# mkcd — make a directory and enter it
function mkcd --description "mkdir -p and cd into it"
    if test (count $argv) -eq 0
        echo "usage: mkcd <dir>" >&2
        return 1
    end
    mkdir -p $argv[1]; and cd $argv[1]
end
