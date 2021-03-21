#!/bin/bash

set -e

type=$1
if [ $# -ne 1 ] || ([ "$type" != "forwarder" ] && [ "$type" != "aggregator" ]); then
  echo "usage: $(basename $0) forwarder|aggregator"
  exit 1
fi

cd $(dirname $0)

outputs=$(terraform output -state=terraform/terraform.tfstate -json)
cluster=$(echo $outputs | jq -r ".application_cluster_name.value")
task_def_arn=$(echo $outputs | jq -r ".application_using_${type}_task_definition_arn.value")
aws ecs run-task --cluster $cluster --task-definition $task_def_arn --count 10
