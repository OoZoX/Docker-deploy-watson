  GNU nano 7.2                                                                                                                  first-load.sh                                                                                                                           
#!/bin/bash

# Configuration des répertoires
PRIVATE_DIR="/secure/private"
PUBLIC_DIR="/secure/public"
KEY_DIR="/secure/keys"

# Création des répertoires
mkdir -p $PRIVATE_DIR $PUBLIC_DIR $KEY_DIR

# Générer une clé AES pour le dossier privé
AES_KEY="$KEY_DIR/private_aes.key"
openssl rand -hex 32 > $AES_KEY
echo "Clé AES générée pour le dossier privé : $AES_KEY"

# Générer une paire de clés RSA pour le dossier public
RSA_PRIVATE_KEY="$KEY_DIR/public_rsa_private.key"
RSA_PUBLIC_KEY="$KEY_DIR/public_rsa_public.key"
openssl genrsa -out $RSA_PRIVATE_KEY 2048
openssl rsa -in $RSA_PRIVATE_KEY -pubout -out $RSA_PUBLIC_KEY
echo "Clés RSA générées pour le dossier public : $RSA_PRIVATE_KEY et $RSA_PUBLIC_KEY"

# Générer des clés symétriques avec CKMS
ckms -- sym keys create --number-of-bits 256 --algorithm aes --tag key-bob-aes || { echo "Erreur CKMS : création de key-bob-aes échouée"; exit 1; }
ckms -- sym keys create --number-of-bits 256 --algorithm aes --tag key-alice-aes || { echo "Erreur CKMS : création de key-alice-aes échouée"; exit 1; }
echo "Clés CKMS créées pour Bob et Alice."

# Création de fichiers d'exemple
echo "Fichier privé exemple" > $PRIVATE_DIR/example_private.txt
echo "Fichier de Bob" > $PRIVATE_DIR/example_bob.txt
echo "Fichier d'Alice" > $PRIVATE_DIR/example_alice.txt
echo "Fichier public exemple" > $PUBLIC_DIR/example_public.txt

# Chiffrement des fichiers dans PRIVATE (AES)
openssl enc -aes-256-cbc -pbkdf2 -salt -in $PRIVATE_DIR/example_private.txt -out $PRIVATE_DIR/example_private.txt.enc -pass file:$AES_KEY
rm $PRIVATE_DIR/example_private.txt

openssl enc -aes-256-cbc -pbkdf2 -salt -in $PRIVATE_DIR/example_bob.txt -out $PRIVATE_DIR/example_bob.txt.enc -pass file:$AES_KEY
rm $PRIVATE_DIR/example_bob.txt

openssl enc -aes-256-cbc -pbkdf2 -salt -in $PRIVATE_DIR/example_alice.txt -out $PRIVATE_DIR/example_alice.txt.enc -pass file:$AES_KEY
rm $PRIVATE_DIR/example_alice.txt

# Chiffrement des fichiers dans PUBLIC (RSA)
openssl pkeyutl -encrypt -inkey $RSA_PUBLIC_KEY -pubin -in $PUBLIC_DIR/example_public.txt -out $PUBLIC_DIR/example_public.txt.enc
rm $PUBLIC_DIR/example_public.txt

echo "Tous les fichiers ont été chiffrés et les dossiers sécurisés sont prêts."
exec bash