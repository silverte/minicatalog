#!/bin/sh

SERVICE=$(aws ecs list-services --cluster ecs-cluster-mctl-prd --query serviceArns --output text)

if [ ${#SERVICE} -ne 0 ]; then
    echo "service exist \n ${SERVICE}";
    echo "update service"
    aws ecs update-service --service=mctl-planner-svc --cluster=ecs-cluster-mctl-prd --task-definition=mctl-planner
    aws ecs update-service --service=mctl-manager-svc --cluster=ecs-cluster-mctl-prd --task-definition=mctl-manager
else
    aws ecs create-service --cluster "ecs-cluster-mctl-prd" --enable-execute-command --cli-input-json file://./main/json/service-planner.json;
    aws ecs create-service --cluster "ecs-cluster-mctl-prd" --enable-execute-command --cli-input-json file://./main/json/service-manager.json;
fi
