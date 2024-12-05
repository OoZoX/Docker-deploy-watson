# Utilisation d'Ubuntu comme image de base
FROM ghcr.io/cosmian/kms

# Installation des dépendances nécessaires
RUN apt-get update && apt-get install -y \
    openssl \
    openssh-server \
    sudo -y \
    && rm -rf /var/lib/apt/lists/*
RUN mkdir /var/run/sshd
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 bob
RUN echo 'bob:root123' | chpasswd
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 999 alice
RUN echo 'alice:root123' | chpasswd
RUN service ssh start

EXPOSE 22

# Copier les scripts init.sh et decrypt.sh dans le conteneur
COPY first-load.sh /usr/local/bin/first-load.sh

# Rendre les scripts exécutables
RUN chmod +x /usr/local/bin/first-load.sh

RUN usermod -aG sudo bob
RUN usermod -aG sudo alice

# ENTRYPOINT ["exec /usr/sbin/sshd -D"]