#!/bin/bash

if [ $# -lt 2 ] ; then
    echo "Usage: $0 stackname domain"
    exit 1
fi

region=us-west-2
domain=$2

echo "Remove Cloudformation Stack: $1"
aws cloudformation delete-stack \
  --region "$region" \
  --stack-name "$1"

echo "Remove S3 bucket:"
aws s3 rm --recursive s3://logs.$domain
aws s3 rb s3://logs.${domain}
aws s3 rb s3://codepipeline.${domain}
aws s3 rb s3://${domain}
aws s3 rb s3://www.${domain}

echo "Remove AWS codecommit repo:"
aws codecommit delete-repository \
    --region "$region" \
    --repository-name "$domain" 

echo "Remove Route53 domain:"
hosted_zone_id=$(
  aws route53 list-hosted-zones \
    --output text \
    --query 'HostedZones[?Name==`'$domain'.`].Id'
)
echo hosted_zone_id=$hosted_zone_id
aws route53 delete-hosted-zone \
  --id "$hosted_zone_id"

