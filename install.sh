#!/bin/bash

# Absolute path of the directory holding this script, so it works no matter
# which directory you run it from.
REPO_DIR="$(cd "$(dirname "$0")" && pwd -P)"
STAMP="$(date +%Y%m%d-%H%M%S)"

# Run a command, or just print it during a dry run.
run() {
    if [ "$DRY_RUN" -eq 1 ]; then
        echo "        would run: $@"
    else
        "$@"
    fi
}

# Symlink all runtime components into the home directory
for file in .bashrc .zshrc .alias .bash_profile .gdbinit .gitconfig .tmux.conf .vimrc; do
    if [ -f "$REPO_DIR/$file" ]; then
        echo "Installing $file..."
        # Backup existing files if they exist and are not symlinks
        if [ -f "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
            mv "$HOME/$file" "$HOME/${file}.bak.${STAMP}"
        fi
        ln -sf "$REPO_DIR/$file" "$HOME/$file"
    fi
done

echo "Installation complete!"

# Install cowsay into ~/.local (no root needed)
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
git clone https://github.com/cowsay-org/cowsay.git
cd cowsay
make install prefix=$HOME/.local

# Add the train cow used by boilersay (site-cows is on cowsay's default path)
mkdir -p "$HOME/.local/share/cowsay/site-cows"
cp "$DOTFILES_DIR/train.cow" "$HOME/.local/share/cowsay/site-cows/"
