#!/bin/bash
echo ECS_CLUSTER=${cluster_name} >> /etc/ecs/ecs.config; echo ECS_BACKEND_HOST= >> /etc/ecs/ecs.config;
echo "ECS_AVAILABLE_LOGGING_DRIVERS=[\"awslogs\",\"gelf\",\"json-file\",\"splunk\"]" >> /etc/ecs/ecs.config;
efs_dns_name=${efs_dns_name}

if  [ -z "$efs_dns_name" ]
then
  echo "no efs"
else
  sudo mkdir /mnt/efs; sudo yum install -y amazon-efs-utils;  sudo mount -t efs $efs_dns_name:/ /mnt/efs;
fi