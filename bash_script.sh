#!/bin/bash
# ------------------------------------------------------------------
#  Author: Mark Russell
#  Description: Creates a scales ECS cluster and services.
# ------------------------------------------------------------------

VERSION=0.1.0


echo 'Running Script'


#Login to the Docker Repo
DOCKER_LOGIN=`aws ecr get-login --region us-east-1`
${DOCKER_LOGIN}


#Configure amd install ecs-cli 
ecs-cli configure --region us-east-1 --cluster pc-cluster

if ! [ -x "$(command -v ecs-cli)" ]; then
  echo 'Error: ecs-cli is not installed, installing .... please wait'
  sudo curl -o /usr/bin/ecs-cli https://s3.amazonaws.com/amazon-ecs-cli/ecs-cli-linux-amd64-latest
  sudo chmod +x /usr/bin/ecs-cli
  echo 'ecs-cli installed'
else
  echo 'ecs-cli check has passed'
fi

set -x

#Get the vpc, subnet and security group ID to create the cluster

vpc=$(aws ec2 describe-vpcs --filter "Name=tag:Name,Values=pc-qa-vpc" --query 'Vpcs[*].{id:VpcId}' | grep id | cut -d"\"" -f4)
subnet=$(aws ec2 describe-subnets --filter "Name=tag:Name,Values=pc-qa-public-subnet-a" --query 'Subnets[*].{id:SubnetId}' | grep id | cut -d "\"" -f4)
sg=$(aws ec2 describe-security-groups --filter "Name=tag:Name,Values=pc-qa-vpc-sg" --query 'SecurityGroups[*].{id:GroupId}' | grep id | cut -d"\"" -f4)



echo 'Creating Cluster'
ecs-cli up -force -keypair pc-key -capability-iam -size 1 -instance-type m4.xlarge -security-group ${sg} --vpc ${vpc} -subnets ${subnet}  

if [ $? -eq 0 ]; then
    echo 'SUCCESS'
else
    echo 'FAILED'
    exit 1
fi

echo 'Creating task definiton from docker-compose.yml and deploying service to cluster'
ecs-cli compose -file docker-compose.yml service up

if [ $? -eq 0 ]; then
    echo 'SUCCESS'
else
    echo 'FAILED'
    exit 1
fi

echo 'Finding auto scaling group'

AUTO_SCALING_GROUP=$(aws autoscaling describe-auto-scaling-groups | grep "ResourceId\": \"amazon-ecs-cli-setup-pc-cluster" | sort -u | cut -d"\"" -f4)

echo 'Found:'$AUTO_SCALING_GROUP

aws autoscaling attach-load-balancers --load-balancer-names pc-elb --auto-scaling-group-name $AUTO_SCALING_GROUP



# echo 'Scaling service across 2 ECS instances'
#ecs-cli compose service scale 2
#if [ $? -eq 0 ]; then
#    echo SUCCESS
#else
#    echo FAILED
#    exit 1
#fi
