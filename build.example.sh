#!/bin/bash

# Save the current directory
CURRENT_DIR=$(pwd)

# cd to where the script is located
cd "$(dirname "$0")"

# Load the environment variables
source .example.env

# Create the directories if they don't exist
if [ ! -d "./data" ]; then
    mkdir ./data
fi

if [ ! -d "./data/pgadmin" ]; then
    mkdir ./data/pgadmin
fi

if [ ! -d "./data/postgres" ]; then
    mkdir ./data/postgres
fi

# If no cert files are found, generate them
if [ ! -f "./data/traefik/localhost.crt" ] || [ ! -f "./data/traefik/localhost.key" ]; then
    echo "Generating self-signed certificates..."
    # Generates a self-signed certificate for localhost and *.localhost
    # valid for 30 days
    # 4096 bit RSA key
    # sha512 signature
    # No passphrase, this is for development only
    openssl req -x509 -out ./data/traefik/localhost.crt -keyout ./data/traefik/localhost.key \
        -newkey rsa:4096 -nodes -sha512 \
        -subj '/CN=localhost' -extensions EXT -config <( \
        printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost,DNS:*.localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")
 fi

# Required for pgadmin to work, otherwise it will not be able to write to the volume
sudo chown -R 5050:5050 ./data/pgadmin

# Build the containers
docker-compose --env-file .example.env up --build --force-recreate -d;

# Return to the original directory
cd $CURRENT_DIR