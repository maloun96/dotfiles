#!/bin/sh

# Symlinks VS Code's user config to this repo and restores the extension list.
# Safe to re-run: existing real files are backed up once, symlinks are refreshed.

DOTFILES="$HOME/.dotfiles"
USERDIR="$HOME/Library/Application Support/Code/User"

if [ ! -d "$USERDIR" ]; then
  echo "VS Code user directory not found — install VS Code first, launch it once, then re-run."
  exit 1
fi

for FILE in settings.json keybindings.json; do
  TARGET="$USERDIR/$FILE"
  # back up a real file we'd otherwise clobber (a symlink carries nothing to lose)
  if [ -f "$TARGET" ] && [ ! -L "$TARGET" ]; then
    mv "$TARGET" "$TARGET.bak-$(date +%Y%m%d-%H%M%S)"
  fi
  ln -sfv "$DOTFILES/vscode/$FILE" "$TARGET"
done

# Reinstall extensions. `code` needs the shell command on $PATH:
# VS Code → Command Palette → "Shell Command: Install 'code' command in PATH"
if command -v code >/dev/null 2>&1; then
  while read -r EXTENSION; do
    [ -n "$EXTENSION" ] && code --install-extension "$EXTENSION" --force
  done < "$DOTFILES/vscode/extensions.txt"
else
  echo "'code' not on \$PATH — skipping extensions. Install the shell command, then re-run."
fi
