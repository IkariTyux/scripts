#!/bin/bash

App=$1
Domain=$2
SSLPath="/home/$USER/Downloads/SSL"
AppPath="$SSLPath/$App"

mkdir -p $AppPath
echo "Generating a certificate for $App with $Domain"
echo ""

cert_gen () {
openssl req -newkey rsa:4096 \
            -x509 \
            -sha256 \
            -days 3650 \
            -nodes \
            -out $AppPath/cert.pem \
            -keyout $AppPath/key.pem \
            -subj "/C=FR/ST=France/L=Paris/O=Eva-Labs/OU=IT Department/CN=$Domain"
}

cert_gen

if [ $? -eq 0 ]
  then echo -e "\033[32m The certificate is now available at $AppPath \033[0m"
  else echo -e "\033[033m Error while generating the certificate \033[0m" && exit
fi
