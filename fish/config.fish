# ~/.config/fish/config.fish  (symlinked from ~/dotfiles/fish)
# Machine-specific settings & secrets go in ~/.config/fish/local.fish (gitignored).

# --- Homebrew (static equivalent of `brew shellenv`, no subprocess) ----------
set -gx HOMEBREW_PREFIX /opt/homebrew
set -gx HOMEBREW_CELLAR /opt/homebrew/Cellar
set -gx HOMEBREW_REPOSITORY /opt/homebrew
set -gx HOMEBREW_CASK_OPTS "--appdir=$HOME/Applications --no-quarantine"
set -gx HOMEBREW_BUNDLE_FILE ~/dotfiles/brew/Brewfile
set -q MANPATH; or set -gx MANPATH ''
set -q INFOPATH; or set -gx INFOPATH ''
set -gx INFOPATH /opt/homebrew/share/info $INFOPATH
# eza looks in ~/Library/Application Support on macOS by default
set -gx EZA_CONFIG_DIR ~/.config/eza

# --- PATH (fish_add_path dedupes; later calls win) --------------------------
fish_add_path -g --append "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
fish_add_path -g /opt/homebrew/bin /opt/homebrew/sbin
fish_add_path -g /opt/homebrew/opt/openssl/bin
fish_add_path -g /opt/homebrew/opt/ruby/bin
fish_add_path -g ~/.local/bin

# Lets ~/.zshrc know not to bounce back into fish when you run `zsh`.
set -gx IN_FISH 1

# --- Editor -----------------------------------------------------------------
if test -x /opt/homebrew/bin/zed
    set -gx EDITOR "zed --wait"
else
    set -gx EDITOR vim
end
set -gx VISUAL $EDITOR

# mise is auto-activated by Homebrew's vendor conf.d (mise.fish); not repeated here.

if status is-interactive
    set -g fish_greeting
    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"

    # Source a tool's init script, regenerated only when the binary changes.
    # Saves ~10-20 ms per tool versus piping `tool init fish | source` each time.
    function _cached_init -a name bin
        set -l cache ~/.cache/fish/init-$name.fish
        if not test -s $cache; or test $bin -nt $cache
            mkdir -p ~/.cache/fish
            $argv[3..] >$cache
        end
        source $cache
    end

    test -x /opt/homebrew/bin/starship; and _cached_init starship /opt/homebrew/bin/starship starship init fish --print-full-init
    test -x /opt/homebrew/bin/zoxide; and _cached_init zoxide /opt/homebrew/bin/zoxide zoxide init fish
    test -x /opt/homebrew/bin/atuin; and _cached_init atuin /opt/homebrew/bin/atuin atuin init fish --disable-up-arrow
    test -x /opt/homebrew/bin/jj; and _cached_init jj /opt/homebrew/bin/jj env COMPLETE=fish jj

    # Abbreviations expand visibly, so the real command is one backspace away.
    abbr -a ls eza --group-directories-first
    abbr -a ll eza -l --git --group-directories-first
    abbr -a la eza -la --git --group-directories-first
    abbr -a lt eza --tree --level=2 --git-ignore
    abbr -a cat bat
    abbr -a top btm
    abbr -a du dust
    abbr -a http xh

    abbr -a j jj
    abbr -a js jj st
    abbr -a jd jj diff
    abbr -a jl jj log
    abbr -a g git
end

# --- Local overrides --------------------------------------------------------
test -f ~/.config/fish/local.fish; and source ~/.config/fish/local.fish
