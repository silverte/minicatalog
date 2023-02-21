docker build -t mctl-manager .
aws ecr get-login-password --region ap-northeast-3 | docker login --username AWS --password-stdin 533616270150.dkr.ecr.ap-northeast-3.amazonaws.com
docker tag mctl-manager:latest 533616270150.dkr.ecr.ap-northeast-3.amazonaws.com/mctl-manager
docker push 533616270150.dkr.ecr.ap-northeast-3.amazonaws.com/mctl-manager

