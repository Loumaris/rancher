#!/bin/sh

echo $CA | base64 -d > ca.crt

# check parameters
if [[ -z "${RESOURCE}" ]]; then
  RESOURCE="deployment"
fi
if [[ -z "${NAMESPACE}" ]]; then
  NAMESPACE="default"
fi
if [[ -z "${URL}" ]]; then
  echo "URL not set"
  exit 1
fi
if [[ -z "${CONTEXT}" ]]; then
  echo "CONTEXT not set"
  exit 1
fi
if [[ -z "${TOKEN}" ]]; then
  echo "TOKEN not set"
  exit 1
fi
if [[ -z "${DEPLOYMENT}" ]]; then
  echo "DEPLOYMENT not set"
  exit 1
fi
if [[ -z "${CONTAINER}" ]]; then
  echo "CONTAINER not set"
  exit 1
fi
if [[ -z "${IMAGE}" ]]; then
  echo "IMAGE not set"
  exit 1
fi

# login to rancher
echo "login: $URL with context: $CONTEXT"
rancher login $URL --token $TOKEN --context $CONTEXT

# print summary
echo ""
echo ""
echo "########### UPDATE CLUSTER #################"
echo "Resource.............. $RESOURCE"
echo "Namespace............. $NAMESPACE"
echo "Deployment............ $DEPLOYMENT"
echo "Container............. $CONTAINER"
echo "Image................. $IMAGE"
echo "########### UPDATE CLUSTER #################"

# exit with error if a deploy-command fails
set -e

# deploy stuff
if [ $RESOURCE = "deployment" ]; then
  rancher kubectl \
    patch $RESOURCE $DEPLOYMENT \
    --namespace $NAMESPACE \
    --type strategic \
    --patch '{"spec": {"template": {"spec": {"containers": [{"name": "'$CONTAINER'","image": "'$IMAGE'"}]}}}}'

  # Check deployment rollout status every 10 seconds (max 10 minutes) until complete.
  attempts=0
  rollout_status_cmd="rancher kubectl rollout status $RESOURCE $DEPLOYMENT --namespace $NAMESPACE "
  until $rollout_status_cmd; do
    $rollout_status_cmd
    attempts=$((attempts + 1))
    sleep 10
    if [ $attempts -eq 60 ]; then 
      exit 2
    fi
  done
fi
if [ $RESOURCE = "cronjob" ]; then
  rancher kubectl \
    patch $RESOURCE $DEPLOYMENT \
    --namespace $NAMESPACE \
    --type strategic \
    --patch  '{"spec": {"jobTemplate": {"spec": {"template": {"spec": {"containers": [{"name": "'$CONTAINER'","image": "'$IMAGE'"}]}}}}}}'
fi