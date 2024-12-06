# Utilisation de cosmian KMS comme base
FROM ghcr.io/cosmian/kms:4.20.0

# Installation des dépendances nécessaires
#RUN apt-get update && apt-get install -y \
RUN apt-get install -y \
    openssl \
    openssh-server \
    sudo \
    sshpass \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /var/run/sshd \
    && useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 bob \
    && echo 'bob:root123' | chpasswd \
    && useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 999 alice \
    && echo 'alice:root123' | chpasswd \
    && service ssh start \
    && usermod -aG sudo bob \
    && usermod -aG sudo alice

# Sensitive
EXPOSE 22

# Copier les scripts init.sh et decrypt.sh dans le conteneur
COPY first-load.sh /usr/local/bin/first-load.sh

RUN chmod +x /usr/local/bin/first-load.sh \
#    && addgroup -S nonroot \
#    && adduser -S nonroot -G nonroot
#USER nonroot
# ENTRYPOINT ["exec /usr/sbin/sshd -D"]