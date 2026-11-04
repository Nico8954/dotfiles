# Use the jj starship prompt inside jj repos (walks up from $PWD, no subprocess).
function _starship_jj_detect --on-variable PWD
    status is-interactive; or return
    set -l dir $PWD
    while test -n "$dir"
        if test -d $dir/.jj
            set -gx STARSHIP_CONFIG ~/.config/starship-jj.toml
            return
        end
        test $dir = /; and break
        set dir (path dirname $dir)
    end
    set -e STARSHIP_CONFIG
end
_starship_jj_detect
