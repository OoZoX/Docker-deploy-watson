  GNU nano 7.2                                                                                                                  first-load.sh                                                                                                                           
#!/bin/bash

# Configuration des répertoires
BOB_DIR="/secure/bob"
ALICE_DIR="/secure/alice"
PUBLIC_DIR="/secure/public"
KEY_DIR="/secure/keys"

# Création des répertoires
mkdir -p $BOB_DIR $PUBLIC_DIR $ALICE_DIR $KEY_DIR

# Générer une paire de clés RSA pour le dossier public
RSA_PRIVATE_KEY="$KEY_DIR/public_rsa_private.key"
RSA_PUBLIC_KEY="$KEY_DIR/public_rsa_public.key"
openssl genrsa -out $RSA_PRIVATE_KEY 2048
openssl rsa -in $RSA_PRIVATE_KEY -pubout -out $RSA_PUBLIC_KEY
echo "Clés RSA générées pour le dossier public : $RSA_PRIVATE_KEY et $RSA_PUBLIC_KEY"

# Générer des clés symétriques avec CKMS
ckms sym keys create --number-of-bits 256 --algorithm aes --tag key-bob-aes || { echo "Erreur CKMS : création de key-bob-aes échouée"; exit 1; }
ckms sym keys create --number-of-bits 256 --algorithm aes --tag key-alice-aes || { echo "Erreur CKMS : création de key-alice-aes échouée"; exit 1; }
echo "Clés CKMS créées pour Bob et Alice."

exec bash