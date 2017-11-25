#!/usr/bin/env sh
#########################################################
##                                                     ##
##                            _                        ##
##             __ _ _ __ __ _(_)_ __   ___             ##
##            / _` | '__/ _` | | '_ \ / _ \            ##
##           | (_| | | | (_| | | | | |  __/            ##
##            \__, |_|  \__,_|_|_| |_|\___|            ##
##            |___/                                    ##
##                                                     ##
##                                                     ##
##-----------------------------------------------------##
##                                                     ##
##  generate.sh                By Mathieu Lescaudron   ##
##                                                     ##
##  V 1.0                      Created on 25/11/2017   ##
##                                                     ##
#########################################################

# INTRODUCTION
#
# Generate a SSL certificate and ensure that domain is pointing
# the same server who will have the certificate

# Check parameters
if [ $# -lt 2 ]; then
	echo "###"
	echo "Usage: $0 domain email"
	exit
fi

export DOMAIN=$1
export EMAIL=$2

# Clean actual .well-knwon directory and prepare it
rm -rf /check/.well-known
mkdir -p /check/.well-known/acme-challenge
echo "ready" > /check/.well-known/acme-challenge/ready.txt

# Ensure that the domain is pointing the server
result=$(curl -s $DOMAIN/.well-known/acme-challenge/ready.txt)

if [[ "$(echo $result)" != "ready" ]]; then
  echo "Your domain does not point to the server or your server does not run the graine/nginx docker images."
  exit
fi

# Call certbot to create the SSL
echo "Create SSL for domain : $DOMAIN"
certbot certonly --webroot  -w /check \
                    -d $DOMAIN \
                    -m $EMAIL \
                    --agree-tos \
                    --no-eff-email \
                    --keep-until-expiring \
                    -q