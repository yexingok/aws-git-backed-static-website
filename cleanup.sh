#!/bin/bash

if [ $# -lt 2 ] ; then
    echo "Usage: $0 stackname domain"
    exit 1
fi

region=us-west-2
domain=$2

echo "Remove Cloudformation Stack: $1"
aws --profile yx cloudformation delete-stack \
  --region "$region" \
  --stack-name "$1"

echo "Remove S3 bucket:"
aws --profile yx s3 rm --recursive s3://logs.$domain
aws --profile yx s3 rb s3://logs.${domain}
aws --profile yx s3 rb s3://codepipeline.${domain}
aws --profile yx s3 rb s3://${domain}
aws --profile yx s3 rb s3://www.${domain}

echo "Remove codecommit repo:"
aws --profile yx codecommit delete-repository \
    --region "$region" \
    --repository-name "$domain" 

echo "Remove Route53 domain:"
hosted_zone_id=$(
  aws --profile yx route53 list-hosted-zones \
    --output text \
    --query 'HostedZones[?Name==`'$domain'.`].Id'
)
echo hosted_zone_id=$hosted_zone_id
#aws --profile yx route53 delete-hosted-zone \
#  --id "$hosted_zone_id"

