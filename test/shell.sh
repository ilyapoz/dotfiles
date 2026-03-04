#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."

docker build -t dotfiles-test -f test/Dockerfile .
docker run --rm -it -e TERM=xterm-256color dotfiles-test zsh
