#!/bin/sh
docker build -t mctl-planner .
aws ecr get-login-password --region ap-northeast-3 | docker login --username AWS --password-stdin 533616270150.dkr.ecr.ap-northeast-3.amazonaws.com
docker tag mctl-planner:latest 533616270150.dkr.ecr.ap-northeast-3.amazonaws.com/mctl-planner
docker push 533616270150.dkr.ecr.ap-northeast-3.amazonaws.com/mctl-planner