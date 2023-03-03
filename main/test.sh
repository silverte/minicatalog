#!/bin/sh

SVC_NAME=mctl-planner
SVC_ARN=$(aws ecs list-tasks --cluster ecs-cluster-mctl-prd --family $SVC_NAME | jq '.taskArns[0]')
URL="internal-alb-mctl-prd-ecs-664525908.ap-northeast-3.elb.amazonaws.com"
#echo $SVC_ARN

echo "aws ecs execute-command  \\
    --cluster ecs-cluster-mctl-prd \\
    --task $SVC_ARN \\
    --container $SVC_NAME \\
    --interactive \\
    --command \"/bin/sh\""

echo "curl $URL/mctl-manager"
