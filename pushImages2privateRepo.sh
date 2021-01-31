#!/bin/sh

for REPO in "$@"
do
  export AWS_ACCOUNT_ID=373619751787
  aws ecr create-repository \
      --repository-name ${REPO} \
      --image-scanning-configuration scanOnPush=true \
      --region ${AWS_REGION}
  docker tag ${REPO}:latest ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO}:latest
  docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO}:latest
done

