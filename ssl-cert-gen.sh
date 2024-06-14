#!/bin/bash

### Define variables
## App name and domain
App=$1 # name of the app (lower case, no spaces, only "-" or "_").
Domain=$2 # Fully qualified Domain name

## Organisation
# Can be changed, or left as it.
Country="JP" # The two-letter ISO abbreviation of a country
State="Japan" # The country or state
City="Tokyo III" # The city
Organisation="Nerv" # The name of the organisation. Can be anything
OrgUnit="IT Department" # Whatever you want it to be

## Paths
SSLPath="/home/$USER/Downloads/SSL"
AppPath="$SSLPath/$App"

### Creation of the folder that stores the cert.
mkdir -p $AppPath
echo "Generating a certificate for $App with $Domain"
echo ""

### Function that requests the certificate using openssl
# Source: https://linuxize.com/post/creating-a-self-signed-ssl-certificate
# The -subj parameters use the Organisation variables
# It stores the certificate and key in the folder named after the $App variable
cert_gen () {
openssl req -newkey rsa:4096 \
            -x509 \
            -sha256 \
            -days 3650 \
            -nodes \
            -out $AppPath/cert.pem \ 
            -keyout $AppPath/key.pem \
            -subj "/C=$Country/ST=$State/L=$City/O=$Organisation/OU=$OrgUnit/CN=$Domain"
}

## Requesting certificate
# Execution of the function
cert_gen

### End of the script
# checks if cert_gen ran successfully or not an outputs the result
if [ $? -eq 0 ]
  then echo -e "\033[32m The certificate is now available at $AppPath \033[0m"
  else echo -e "\033[033m Error while generating the certificate \033[0m" && exit
fi
