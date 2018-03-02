#!/bin/bash
# Pre-requirement awscli
# Example: Request a ssl certs with domain example.com
# ./request-ssl.cert.sh example.com

if [ $# -lt 1 ] ; then 
    echo "Usage: $0 example.com"
    exit 1
fi

domain=$1
region=us-east-1

aws acm request-certificate \
    --region ${region} \
    --domain-name ${domain} \
    --subject-alternative-name www.${domain} 

