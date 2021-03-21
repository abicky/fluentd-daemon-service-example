#!/bin/bash

set -e

cd $(dirname $0)

cd terraform
terraform apply
outputs=$(terraform output -json)
cd ..

repository_host=$(echo $outputs | jq -r .fluentd_forwarder_repository_url.value | sed 's|/.*||')
aws ecr get-login-password | docker login --username AWS --password-stdin $repository_host
for app in application fluentd-forwarder fluentd-aggregator; do
  cd $app
  tag=$(echo $outputs | jq -r ".$(echo $app | sed s/-/_/g)_repository_url.value"):latest
  docker build . -t $tag
  docker push $tag
  cd ..
done

cat <<MSG
Execute the following commands if the docker images were updated:
    aws ecs update-service --cluster $(echo $outputs | jq -r .application_cluster_name.value) --service $(echo $outputs | jq -r .fluentd_forwarder_service_name.value) --force-new-deployment
    aws ecs update-service --cluster $(echo $outputs | jq -r .fluentd_aggregator_cluster_name.value) --service $(echo $outputs | jq -r .fluentd_aggregator_service_name.value) --force-new-deployment
MSG
