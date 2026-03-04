FROM ubuntu:22.04

# Layer 1: System packages (cached unless this block changes)
RUN apt-get update -qq && \
    apt-get install -y -qq sudo git zsh tmux vim tig curl && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -m -s /bin/bash testuser && \
    echo 'testuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER testuser
WORKDIR /home/testuser

# Layer 2: Pre-clone slow git repos (cached unless this block changes)
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
    ~/.fzf/install --all --no-bash --no-fish 2>/dev/null || true
RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
RUN git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Layer 3: Copy plugin configs only (cached unless these specific files change)
COPY --chown=testuser:testuser vimrc.plugins /home/testuser/.vimrc.plugins
COPY --chown=testuser:testuser vimrc /home/testuser/.vimrc
COPY --chown=testuser:testuser tmux.conf /home/testuser/.tmux.conf

# Layer 4: Install plugins (cached unless plugin configs change)
RUN vim +PluginInstall +qall 2>/dev/null || true
RUN ~/.tmux/plugins/tpm/bin/install_plugins

# Layer 5: Copy all dotfiles (invalidates on any file change)
COPY --chown=testuser:testuser . /home/testuser/dotfiles

# Layer 6: Run install.sh (fast - skips clones/apt/plugins, just symlinks)
RUN /home/testuser/dotfiles/install.sh

CMD ["bash"]
