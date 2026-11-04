# dotfiles

Everything is symlinked into place by `install.sh` (idempotent; replaced files go to `~/.dotfiles-backup/<timestamp>/`).

```sh
./install.sh            # link configs
./install.sh --brew     # + brew bundle (brew/Brewfile)
./install.sh --shell    # + make fish the login shell
```

| dir        | linked to |
|------------|-----------|
| `fish/`    | `~/.config/fish/{config.fish,conf.d,functions}` |
| `jj/`      | `~/.config/jj/config.toml` |
| `git/`     | `~/.config/git/{config,ignore,allowed_signers,catppuccin.gitconfig}` |
| `ghostty/` | `~/.config/ghostty/config.ghostty` |
| `zed/`     | `~/.config/zed/{settings,keymap}.json` |
| `claude/`  | `~/.claude/settings.json` |
| `ssh/`     | `~/.ssh/config` |
| `starship/`, `bat/`, `eza/`, `yazi/`, `atuin/` | `~/.config/<tool>/…` |
| `bottom/`  | `~/Library/Application Support/bottom/bottom.toml` |
| `brew/`    | `Brewfile` (`$HOMEBREW_BUNDLE_FILE` points here, so plain `brew bundle` works) |

Theme: **Catppuccin Mocha** everywhere (Ghostty, fish, starship, delta/bat, eza, yazi, bottom, atuin, Zed). jj and jjui use the terminal's ANSI palette, so they follow Ghostty.

## Secrets & machine-local config

Nothing secret is committed. Only *public* keys appear (`ssh/id_ed25519.pub`, jj signing key, `git/allowed_signers`). Private keys stay in `~/.ssh` and are loaded via the macOS keychain (`UseKeychain`/`AddKeysToAgent`).

Machine-specific settings go in these gitignored files:

- `~/.config/fish/local.fish`: env vars, tokens, work aliases
- `~/.ssh/config.local`: work hosts
- `~/.config/git/config.local`: per-machine git overrides

`~/.gitconfig` is managed by IT/SYS and left alone; git also reads `~/.config/git/config` (ours).

## New machine

1. Install Homebrew, clone this repo to `~/dotfiles`
2. `./install.sh --brew --shell`
3. Copy/generate `~/.ssh/id_ed25519`, then `ssh-add --apple-use-keychain ~/.ssh/id_ed25519`
