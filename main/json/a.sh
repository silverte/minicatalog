#!bin/bash
SVC_NAME=$1
SVC_ARN=$(aws ecs list-tasks --cluster ecs-cluster-mctl-prd --family $SVC_NAME | jq '.taskArns[0]')
echo $SVC_ARN

