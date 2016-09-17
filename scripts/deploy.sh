#!/bin/bash
# This script generate all the infrastructure elements needed to run and deploy it on AWS.

read -p "Insert Access Key: " AWS_ACCESS_KEY_ID
read -p "Insert Secret Key: " AWS_SECRET_ACCESS_KEY

export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY


if ! type aws >> /dev/null ; then
  echo "There is no AWS Cli packaged installed. Let's install it."
  sudo yum install wget unzip -y
  sudo wget --quiet https://s3.amazonaws.com/aws-cli/awscli-bundle.zip -O /tmp/awscli-bundle.zip && unzip -qo /tmp/awscli-bundle.zip -d /tmp/ && /tmp/awscli-bundle/install -i /usr/local/aws -b /usr/bin/aws
fi

aws ec2 create-key-pair --key-name docker-job --region us-east-1 --query 'KeyMaterial' --output text > docker-job.pem
chmod 600 docker-job.pem

aws cloudformation create-stack --stack-name DockerJob --template-body file://application_stack_template.json --region us-east-1 --capabilities CAPABILITY_IAM
