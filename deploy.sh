#!/bin/sh

echo $CA | base64 -d > ca.crt

echo "login: $URL with context: $CONTEXT"

rancher login $URL --token $TOKEN --context $CONTEXT

echo ""
echo ""
echo "########### UPDATE CLUSER #################"
echo "Namespace............. $NAMESPACE"
echo "Deployment............ $DEPLOYMENT"
echo "Container............. $CONTAINER"
echo "Image................. $IMAGE"
echo "########### UPDATE CLUSER #################"


rancher kubectl --namespace $NAMESPACE patch deployment $DEPLOYMENT --type strategic --patch  '{"spec": {"template": {"spec": {"containers": [{"name": "'$CONTAINER'","image": "'$IMAGE'"}]}}}}'
