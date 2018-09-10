#!/bin/bash

domain=example.com
email=email@your_email.com
# run request-ssl-cert.sh to get the arn:aws string 
cert=arn:aws:acm:us-east-1:xxxxx:certificate/fffffff-973f-46ad-8a1d-85d02e1299ac

region=us-west-2
template=yexing-blog.yml
stackname=${domain/./-}-$(date +%Y%m%d-%H%M%S)

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

