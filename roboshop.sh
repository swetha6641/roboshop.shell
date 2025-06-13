#!/bin/bash
AMI="ami-09c813fb71547fc4f"
SG="sg-0a678a7f0d29620a4"
INSTANCES=("mongodb" "redis" "mysql" "catalogue" "rabbitmq" "user" "cart" "shiiping" "payment" "dispatch" "frontened")
zoneid="Z06739001OLF9ITWI9A5S"
domain="swetha.fun"

for instance in ${INSTANCES[@]}
do 
   INSTANCE_ID=$(aws ec2 run-instances --image-id ami-09c813fb71547fc4f --instance-type t2.micro --security-group-ids sg-0a678a7f0d29620a4 --tag-specifications "ResourceType=instance,Tags=[{Key=Name, Value=$instance}]" --query "Instances[0].InstanceId" --output text)
  if [ $instance != "frontened" ]
  then 
     IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PrivateIpAddress" --output text)
  else 
     IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
   fi
   echo "$instance IP ADDRESS: $IP"
done 
 