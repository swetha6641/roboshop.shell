#!/bin/bash
AMI="ami-09c813fb71547fc4f"
SG="sg-0a678a7f0d29620a4"
instances=("mongodb" "redis" "mysql" "catalogue" "rabbitmq" "user" "cart" "shiiping" "payment" "dispatch" "fromtened")
zoneid="Z06739001OLF9ITWI9A5S"
domain="swetha.fun"

for instance in ${instances[@]}
do 
   instance_id= $(aws ec2 run-instances --image-id ami-09c813fb71547fc4f --instance-type t2.micro 
  --security-group-ids sg-0a678a7f0d29620a4  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=sample1}]' --query "instance[0].instanceid" --output text)
  if [ $instance !="frontened" ]
  then 
     IP=aws ec2 describe-instances --instance-ids $instance_id --query 'Reservations[*].Instances[*].PrivateIpAddress' --output text
  else 
     IP=aws ec2 describe-instances --instance-ids $instance_id --query 'Reservations[*].Instances[*].PublicIpAddress' --output text
   fi
   echo "$instance_id IP ADDRESS: $IP"
done 
