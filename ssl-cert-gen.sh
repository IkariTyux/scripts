#!/bin/bash

### Define variables
## App name and domain
App=$1 # name of the app (lower case, no spaces, only "-" or "_").
Domain=$2 # Fully qualified Domain name
AppPath=$3 # Path for the Cert

## Organisation
# Can be changed, or left as it.
Country="JP" # The two-letter ISO abbreviation of a country
State="Japan" # The country or state
City="Tokyo III" # The city
Organisation="Nerv" # The name of the organisation. Can be anything
OrgUnit="IT Department" # Whatever you want it to be

### Creation of the folder that stores the cert.
## Checks if a Path as been defined. If it's the case, creates it.
## If not, uses current directory.
if [ ! -z "${AppPath}" ]
then
  mkdir -p $AppPath
else
  AppPath="."
fi

echo "Generating a new certificate"
echo ""

## Requesting certificate
openssl req -new \
	-newkey rsa:4096 \
	-x509 \
        -sha256 \
        -days 3650 \
        -nodes \
        -out $AppPath/cert.pem \
	-keyout $AppPath/key.pem \
        -subj "/C=$Country/ST=$State/L=$City/O=$Organisation/OU=$OrgUnit/CN=$Domain"

### End of the script
# checks if the command ran successfully or not an outputs the result
if [ $? -eq 0 ]
  then echo -e "\033[32m The new certificate is now available at $AppPath \033[0m"
  else echo -e "\033[033m Error while generating the certificate \033[0m" && exit
fi
