#!/bin/bash

domain=blog.example.com
email=abc@example.com
# run request-ssl-cert.sh to get the arn:aws string 
cert=arn:aws:acm:us-east-1:xxxxxx:certificate/aabbccdd-abcd-cded-cdcc-ecb8537293e3

region=us-west-2
template=single-dns-blog.yml
stackname=${domain//./-}-$(date +%Y%m%d-%H%M%S)

aws --profile yx cloudformation create-stack \
  --region "$region" \
  --stack-name "$stackname" \
  --capabilities CAPABILITY_IAM \
  --template-body "file://$template" \
  --tags "Key=Name,Value=$stackname" \
  --on-failure "ROLLBACK" \
  --parameters \
    "ParameterKey=DomainName,ParameterValue=$domain" \
    "ParameterKey=NotificationEmail,ParameterValue=$email" \
    "ParameterKey=AWSCertificateArn,ParameterValue=$cert" \

echo region=$region stackname=$stackname

