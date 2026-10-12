# extract — unpack common archives
function extract --description "Unpack common archive formats"
    if test (count $argv) -eq 0
        echo "usage: extract <file>..." >&2
        return 1
    end
    for f in $argv
        if not test -f $f
            echo "extract: not a file: $f" >&2
            return 1
        end
        switch $f
            case '*.tar.gz' '*.tgz'
                tar xzf $f
            case '*.tar.bz2' '*.tbz2'
                tar xjf $f
            case '*.tar.xz' '*.txz'
                tar xJf $f
            case '*.tar.zst'
                tar --zstd -xf $f
            case '*.tar'
                tar xf $f
            case '*.zip'
                unzip $f
            case '*.gz'
                gunzip -k $f
            case '*.bz2'
                bunzip2 -k $f
            case '*.xz'
                unxz -k $f
            case '*.7z'
                7z x $f
            case '*'
                echo "extract: unknown format: $f" >&2
                return 1
        end
    end
end
