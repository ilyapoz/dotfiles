#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- env/PATH setup ---
echo "==> Setting up PATH and shell profiles..."
mkdir -p ~/local/bin
mkdir -p ~/.rc.d

# PATH in login shell profiles
grep -q 'local/bin' ~/.zprofile 2>/dev/null || echo 'export PATH=~/local/bin:$PATH' >> ~/.zprofile
grep -q 'local/bin' ~/.profile 2>/dev/null  || echo 'export PATH=~/local/bin:$PATH' >> ~/.profile

# Bash fallback: source rc.d files
if ! grep -q 'rc.d' ~/.bashrc 2>/dev/null; then
  cat >> ~/.bashrc <<'BLOCK'

for file in ~/.rc.d/*; do
  [ -f "$file" ] && source "$file"
done
BLOCK
fi

# --- package installation ---
SUDO=""
if [ "$(id -u)" -ne 0 ] && command -v sudo &>/dev/null; then
  SUDO="sudo"
fi

if command -v apt-get &>/dev/null; then
  echo "==> Installing packages via apt..."
  $SUDO apt-get update -qq
  $SUDO apt-get install -y -qq zsh tmux vim tig curl
fi

# --- fzf (install from git for latest version) ---
if [ ! -d ~/.fzf ]; then
  echo "==> Installing fzf from git..."
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all --no-bash --no-fish 2>/dev/null || true
else
  echo "==> fzf already installed, skipping."
fi

# --- git ---
echo "==> Configuring git..."
ln -sf "$DOTFILES_DIR/gitconfig" ~/.gitconfig

# --- terminfo ---
echo "==> Installing terminfo entries..."
for f in "$DOTFILES_DIR"/terminfo/*; do
  base="$(basename "$f")"
  first="${base:0:1}"
  mkdir -p ~/.terminfo/"$first"
  cp "$f" ~/.terminfo/"$first/$base"
done

# --- tmux ---
echo "==> Configuring tmux..."
if [ ! -d ~/.tmux/plugins/tpm ]; then
  echo "    Installing tpm..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
ln -sf "$DOTFILES_DIR/tmux.conf" ~/.tmux.conf
cp "$DOTFILES_DIR/rc.d/preexec.sh" ~/.rc.d/preexec.sh
echo "    Installing tmux plugins..."
~/.tmux/plugins/tpm/bin/install_plugins

# --- vim ---
echo "==> Configuring vim..."
mkdir -p ~/.backup
mkdir -p ~/.vim/ftplugin

ln -sf "$DOTFILES_DIR/vimrc" ~/.vimrc
cp -n "$DOTFILES_DIR/vimrc.local" ~/.vimrc.local 2>/dev/null || true
ln -sf "$DOTFILES_DIR/vimrc.plugins" ~/.vimrc.plugins
cp "$DOTFILES_DIR/rc.d/editor" ~/.rc.d/editor
ln -sf "$DOTFILES_DIR/vim/filetype.vim" ~/.vim/filetype.vim
for f in "$DOTFILES_DIR"/vim/ftplugin/*.vim; do
  ln -sf "$f" ~/.vim/ftplugin/"$(basename "$f")"
done

if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
  echo "    Installing Vundle..."
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
echo "    Installing vim plugins..."
vim +PluginInstall +qall 2>/dev/null || true

# --- zsh ---
echo "==> Configuring zsh..."
ln -sf "$DOTFILES_DIR/zshrc.local" ~/.zshrc.local

if [ ! -f ~/.zshrc ]; then
  touch ~/.zshrc
fi
if ! grep -q 'zshrc.local' ~/.zshrc 2>/dev/null; then
  echo '[ -f ~/.zshrc.local ] && source ~/.zshrc.local' >> ~/.zshrc
fi

# --- local/bin scripts ---
echo "==> Installing local/bin scripts..."
cat > ~/local/bin/dotfiles-pull <<EOF
#!/bin/sh
set -e
cd "$DOTFILES_DIR"
echo "Pulling in $DOTFILES_DIR ..."
if git pull | grep -q 'Already up to date'; then
  echo "Already up to date."
else
  echo "Running install.sh ..."
  exec ./install.sh
fi
EOF
chmod +x ~/local/bin/dotfiles-pull

echo "==> Dotfiles installed successfully."
