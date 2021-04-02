#!/bin/sh

echo $CA | base64 -d > ca.crt

# check parameters
if [[ -z "${NAMESPACE}" ]]; then
  NAMESPACE="default"
fi
if [[ -z "${URL}" ]]; then
  echo "URL not set"
  exit 1
fi

# login to rancher
echo "login: $URL with context: $CONTEXT"
rancher login $URL --token $TOKEN --context $CONTEXT

# Patch deployment
echo ""
echo ""
echo "########### UPDATE CLUSER #################"
echo "Namespace............. $NAMESPACE"
echo "Deployment............ $DEPLOYMENT"
echo "Container............. $CONTAINER"
echo "Image................. $IMAGE"
echo "########### UPDATE CLUSER #################"
rancher kubectl --namespace $NAMESPACE patch deployment $DEPLOYMENT --type strategic --patch  '{"spec": {"template": {"spec": {"containers": [{"name": "'$CONTAINER'","image": "'$IMAGE'"}]}}}}'

# Check deployment rollout status every 10 seconds (max 10 minutes) until complete.
attempts=0
rollout_status_cmd="rancher kubectl rollout status deployment/$DEPLOYMENT --namespace $NAMESPACE "
until $rollout_status_cmd; do
  $rollout_status_cmd
  attempts=$((attempts + 1))
  sleep 10
#   if [ $attempts -eq 60 ]; then 
#     exit 2
#   fi
done

exit 0