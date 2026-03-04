#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."

echo "=== Building test image ==="
docker build -t dotfiles-test -f test/Dockerfile .

echo ""
echo "=== Running install.sh + verification ==="
docker run --rm dotfiles-test bash -c '
  ~/dotfiles/install.sh

  echo ""
  echo "=== Verifying ==="
  FAIL=0
  check() {
    if eval "$2"; then
      echo "  OK: $1"
    else
      echo "  FAIL: $1"
      FAIL=1
    fi
  }

  check "~/.vimrc symlink"        "[ -L ~/.vimrc ]"
  check "~/.vimrc.plugins symlink" "[ -L ~/.vimrc.plugins ]"
  check "~/.gitconfig symlink"    "[ -L ~/.gitconfig ]"
  check "~/.tmux.conf symlink"    "[ -L ~/.tmux.conf ]"
  check "~/.zshrc.local symlink"  "[ -L ~/.zshrc.local ]"
  check "~/.vim/ftplugin dir"     "[ -d ~/.vim/ftplugin ]"
  check "~/.backup dir"           "[ -d ~/.backup ]"
  check "~/.rc.d dir"             "[ -d ~/.rc.d ]"
  check "~/.rc.d/editor file"     "[ -f ~/.rc.d/editor ]"
  check "~/.rc.d/preexec.sh file" "[ -f ~/.rc.d/preexec.sh ]"
  check "~/.terminfo exists"      "[ -d ~/.terminfo ]"
  check "bashrc sources rc.d"     "grep -q rc.d ~/.bashrc"
  check "zprofile has local/bin"  "grep -q local/bin ~/.zprofile"
  check "tpm installed"           "[ -d ~/.tmux/plugins/tpm ]"
  check "Vundle installed"        "[ -d ~/.vim/bundle/Vundle.vim ]"
  check "vim ftplugin symlinks"   "[ -L ~/.vim/ftplugin/ruby.vim ]"
  check "fzf installed"           "[ -d ~/.fzf ]"
  check "fzf binary"             "~/.fzf/bin/fzf --version >/dev/null 2>&1"
  check "tig installed"           "command -v tig >/dev/null"
  check "zsh installed"           "command -v zsh >/dev/null"
  check "tmux installed"          "command -v tmux >/dev/null"
  check "vim installed"           "command -v vim >/dev/null"
  check "~/.zshrc exists"         "[ -f ~/.zshrc ]"
  check "zshrc sources zshrc.local" "grep -q zshrc.local ~/.zshrc"

  exit $FAIL
'
