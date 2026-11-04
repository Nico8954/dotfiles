#!/usr/bin/env bash
# Symlink dotfiles into place. Idempotent: safe to re-run.
# Existing real files are moved to ~/.dotfiles-backup/<timestamp>/ first.
#
#   ./install.sh          link configs
#   ./install.sh --brew   also run `brew bundle`
#   ./install.sh --shell  also make fish the login shell (asks for password)
set -euo pipefail

DOT="$(cd "$(dirname "$0")" && pwd)"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

link() { # link <repo-path> <target>
  local src="$DOT/$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    return
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mkdir -p "$BACKUP"
    mv "$dst" "$BACKUP/"
    echo "  backed up $dst -> $BACKUP/"
  fi
  ln -s "$src" "$dst"
  echo "  linked $dst"
}

echo "Linking configs…"
# fish: link the files/dirs, not ~/.config/fish itself (fish writes state there)
link fish/config.fish      "$HOME/.config/fish/config.fish"
link fish/conf.d           "$HOME/.config/fish/conf.d"
link fish/functions        "$HOME/.config/fish/functions"

# jj: only the user config; ~/.config/jj/repos holds per-repo state
link jj/config.toml        "$HOME/.config/jj/config.toml"

link git/config            "$HOME/.config/git/config"
link git/ignore            "$HOME/.config/git/ignore"
link git/allowed_signers   "$HOME/.config/git/allowed_signers"

link git/catppuccin.gitconfig "$HOME/.config/git/catppuccin.gitconfig"

link ghostty/config.ghostty "$HOME/.config/ghostty/config.ghostty"

link starship/starship.toml "$HOME/.config/starship.toml"
link bat/config            "$HOME/.config/bat/config"
link eza/theme.yml         "$HOME/.config/eza/theme.yml"
link yazi/theme.toml       "$HOME/.config/yazi/theme.toml"
link yazi/Catppuccin-mocha.tmTheme "$HOME/.config/yazi/Catppuccin-mocha.tmTheme"
link atuin/config.toml     "$HOME/.config/atuin/config.toml"
link atuin/themes          "$HOME/.config/atuin/themes"
link bottom/bottom.toml    "$HOME/Library/Application Support/bottom/bottom.toml"

link zed/settings.json     "$HOME/.config/zed/settings.json"
link zed/keymap.json       "$HOME/.config/zed/keymap.json"

# claude: only settings; ~/.claude is full of runtime state
link claude/settings.json  "$HOME/.claude/settings.json"

link zsh/zshrc             "$HOME/.zshrc"

# ssh: config only. Private keys are never touched or committed.
link ssh/config            "$HOME/.ssh/config"
chmod 700 "$HOME/.ssh"
touch "$HOME/.ssh/config.local"

if [[ " $* " == *" --brew "* ]]; then
  echo "Installing Brewfile…"
  brew bundle --file="$DOT/brew/Brewfile"
fi

if [[ " $* " == *" --shell "* ]]; then
  FISH="$(command -v fish)"
  if id -Gn | tr ' ' '\n' | grep -qx admin; then
    grep -qx "$FISH" /etc/shells || echo "$FISH" | sudo tee -a /etc/shells >/dev/null
    [ "$SHELL" = "$FISH" ] || chsh -s "$FISH"
    echo "Login shell set to $FISH (open a new terminal)."
  else
    echo "No admin rights: keeping zsh as login shell; ~/.zshrc hands interactive"
    echo "terminals to fish. (Ask IT to add $FISH to /etc/shells for a real chsh.)"
  fi
fi

echo "Done."
