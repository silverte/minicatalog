#!/bin/bash

SERVICE=$(aws ecs list-services --cluster ecs-cluster-mctl-prd --query serviceArns --output text)

if [ ${#SERVICE} -ne 0 ]; then
    echo "service exist \n ${SERVICE}";
    aws ecs delete-service --cluster ecs-cluster-mctl-prd --service mctl-planner-svc --force
    aws ecs delete-service --cluster ecs-cluster-mctl-prd --service mctl-manager-svc --force
    echo "service is terminating... for a long time"
else
    aws ecs create-service --cluster "ecs-cluster-mctl-prd" --enable-execute-command --cli-input-json file://json/service-planner.json;
    aws ecs create-service --cluster "ecs-cluster-mctl-prd" --enable-execute-command --cli-input-json file://json/service-manager.json;
fi
