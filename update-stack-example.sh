#!/bin/bash

domain=example.com
email=yourname@gmail.com
# run request-ssl-cert.sh to get the arn:aws string 
cert=arn:aws:acm:us-east-1:12345:certificate/f42b46ea-983f-36ad-aa1d-95d02e1299ac

region=us-west-2
template=single-dns-blog.yml
stackname=example.com

aws --profile yx cloudformation update-stack \
  --region "$region" \
  --stack-name "$stackname" \
  --capabilities CAPABILITY_IAM \
  --template-body "file://$template" \
  --tags "Key=Name,Value=$stackname" \
  --parameters \
    "ParameterKey=DomainName,ParameterValue=$domain" \
    "ParameterKey=NotificationEmail,ParameterValue=$email" \
    "ParameterKey=AWSCertificateArn,ParameterValue=$cert" \
    "ParameterKey=GeneratorLambdaFunctionS3Key,ParameterValue=lambda/static-site-generator-hugo-0.54.zip" \
    "ParameterKey=DefaultTTL,ParameterValue=3600" \
    "ParameterKey=MinimumTTL,ParameterValue=1800" 

echo region=$region stackname=$stackname

