  GNU nano 7.2                                                                                                                  first-load.sh                                                                                                                           
#!/bin/bash

# Configuration des répertoires
BOB_DIR="/secure/bob"
ALICE_DIR="/secure/alice"
PUBLIC_DIR="/secure/public"
KEY_DIR="/secure/keys"

PASSWORD="root123"
# Création des répertoires
echo "$PASSWORD" | sudo -S mkdir -p $BOB_DIR $PUBLIC_DIR $ALICE_DIR $KEY_DIR

# Changement propriétaire repertoir
echo "$PASSWORD" | sudo -S chown alice /secure/alice
echo "$PASSWORD" | sudo -S chown bob /secure/bob

echo "$PASSWORD" | sudo -S groupadd public
echo "$PASSWORD" | sudo -S usermod -a -G public alice
echo "$PASSWORD" | sudo -S usermod -a -G public bob
echo "$PASSWORD" | sudo -S chgrp public /secure/public
echo "$PASSWORD" | sudo -S chmod 777 public

# Générer une paire de clés RSA pour le dossier public
RSA_PRIVATE_KEY="$KEY_DIR/public_rsa_private.key"
RSA_PUBLIC_KEY="$KEY_DIR/public_rsa_public.key"
echo "$PASSWORD" | sudo -S openssl genrsa -out $RSA_PRIVATE_KEY 2048
echo "$PASSWORD" | sudo -S openssl rsa -in $RSA_PRIVATE_KEY -pubout -out $RSA_PUBLIC_KEY
echo "Clés RSA générées pour le dossier public : $RSA_PRIVATE_KEY et $RSA_PUBLIC_KEY"

# Générer des clés symétriques avec CKMS
echo "$PASSWORD" | sudo -S ckms sym keys create --number-of-bits 256 --algorithm aes --tag key-bob-aes || { echo "Erreur CKMS : création de key-bob-aes échouée"; exit 1; }
echo "$PASSWORD" | sudo -S ckms sym keys create --number-of-bits 256 --algorithm aes --tag key-alice-aes || { echo "Erreur CKMS : création de key-alice-aes échouée"; exit 1; }
echo "Clés CKMS créées pour Bob et Alice."
