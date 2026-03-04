FROM ubuntu:22.04

RUN apt-get update -qq && \
    apt-get install -y -qq sudo git && \
    useradd -m -s /bin/bash testuser && \
    echo 'testuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

COPY . /home/testuser/dotfiles
RUN chown -R testuser:testuser /home/testuser/dotfiles

USER testuser
WORKDIR /home/testuser

CMD ["/home/testuser/dotfiles/install.sh"]
