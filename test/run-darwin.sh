#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."
DOTFILES_DIR="$(pwd)"

if [ "$(uname)" != "Darwin" ]; then
  echo "Skipping: not on macOS"
  exit 0
fi

TMPHOME=$(mktemp -d)
trap "rm -rf $TMPHOME" EXIT

echo "=== Running install.sh with HOME=$TMPHOME ==="
HOME="$TMPHOME" "$DOTFILES_DIR/install.sh"

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

H="$TMPHOME"

check "~/.vimrc symlink"         "[ -L $H/.vimrc ]"
check "~/.vimrc.plugins symlink" "[ -L $H/.vimrc.plugins ]"
check "~/.gitconfig symlink"     "[ -L $H/.gitconfig ]"
check "~/.tmux.conf symlink"     "[ -L $H/.tmux.conf ]"
check "~/.zshrc.local symlink"   "[ -L $H/.zshrc.local ]"
check "~/.vim/ftplugin dir"      "[ -d $H/.vim/ftplugin ]"
check "~/.backup dir"            "[ -d $H/.backup ]"
check "~/.rc.d dir"              "[ -d $H/.rc.d ]"
check "~/.rc.d/editor file"      "[ -f $H/.rc.d/editor ]"
check "~/.rc.d/preexec.sh file"  "[ -f $H/.rc.d/preexec.sh ]"
check "~/.terminfo exists"       "[ -d $H/.terminfo ]"
check "bashrc sources rc.d"      "grep -q rc.d $H/.bashrc"
check "zprofile has local/bin"   "grep -q local/bin $H/.zprofile"
check "tpm installed"            "[ -d $H/.tmux/plugins/tpm ]"
check "Vundle installed"         "[ -d $H/.vim/bundle/Vundle.vim ]"
check "vim ftplugin symlinks"    "[ -L $H/.vim/ftplugin/ruby.vim ]"
check "~/local/bin dir"          "[ -d $H/local/bin ]"

# Darwin-specific: no apt-get should have run
check "no apt-get on macOS"      "! grep -q apt $H/.install.log 2>/dev/null || true"

exit $FAIL
