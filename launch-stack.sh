#!/bin/bash

domain=example.com
email=email@your_email.com
# run request-ssl-cert.sh to get the arn:aws string 
cert=arn:aws:acm:us-east-1:xxxxx:certificate/fffffff-973f-46ad-8a1d-85d02e1299ac

region=us-west-2
template=aws-git-backed-static-website-cloudformation-us-west-2.yml
stackname=${domain/./-}-$(date +%Y%m%d-%H%M%S)

aws cloudformation create-stack \
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
    "ParameterKey=GeneratorLambdaFunctionS3Bucket,ParameterValue=run.yexingok.cc" \
    "ParameterKey=GeneratorLambdaFunctionS3Key,ParameterValue=lambda/static-site-generator-hugo-0.29.zip" \
    "ParameterKey=SyncLambdaFunctionS3Bucket,ParameterValue=run.yexingok.cc" \
    "ParameterKey=SyncLambdaFunctionS3Key,ParameterValue=lambda/aws-lambda-git-backed-static-website.zip" \
    "ParameterKey=PriceClass,ParameterValue=PriceClass_200" \

echo region=$region stackname=$stackname

