#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- env role equivalent ---
mkdir -p ~/local/bin
grep -q 'local/bin' ~/.zprofile 2>/dev/null || echo 'export PATH=~/local/bin:$PATH' >> ~/.zprofile
grep -q 'local/bin' ~/.profile 2>/dev/null  || echo 'export PATH=~/local/bin:$PATH' >> ~/.profile

mkdir -p ~/.rc.d

if ! grep -q 'rc.d' ~/.bashrc 2>/dev/null; then
  cat >> ~/.bashrc <<'BLOCK'

for file in ~/.rc.d/*; do
  if [ -f $file ]; then
      source $file
  fi
done
BLOCK
fi

# --- coder role equivalent (package installation) ---
if command -v apt-get &>/dev/null; then
  sudo apt-get update -qq
  sudo apt-get install -y -qq fzf tig
fi

# --- git role ---
ln -sf "$DOTFILES_DIR/gitconfig" ~/.gitconfig

# --- term role ---
for f in "$DOTFILES_DIR"/terminfo/*; do
  base="$(basename "$f")"
  first="${base:0:1}"
  mkdir -p ~/.terminfo/"$first"
  cp "$f" ~/.terminfo/"$first/$base"
done

# --- tmux role ---
if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
ln -sf "$DOTFILES_DIR/tmux.conf" ~/.tmux.conf
cp "$DOTFILES_DIR/rc.d/preexec.sh" ~/.rc.d/preexec.sh

# --- vim role ---
mkdir -p ~/.backup
mkdir -p ~/.vim/ftplugin

ln -sf "$DOTFILES_DIR/vimrc" ~/.vimrc
cp "$DOTFILES_DIR/vimrc.local" ~/.vimrc.local 2>/dev/null || true  # don't overwrite if exists
ln -sf "$DOTFILES_DIR/vimrc.plugins" ~/.vimrc.plugins
cp "$DOTFILES_DIR/rc.d/editor" ~/.rc.d/editor
ln -sf "$DOTFILES_DIR/vim/filetype.vim" ~/.vim/filetype.vim
for f in "$DOTFILES_DIR"/vim/ftplugin/*.vim; do
  ln -sf "$f" ~/.vim/ftplugin/"$(basename "$f")"
done

if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
vim +PluginInstall +qall 2>/dev/null || true

# --- zsh role ---
ln -sf "$DOTFILES_DIR/zshrc.local" ~/.zshrc.local

echo "Dotfiles installed successfully."
