#!/bin/bash
# Deploy RSVP microservice to EKS
set -e
cd $(dirname $0)/..

NAMESPACE=rsvp
kubectl create namespace $NAMESPACE || true

# Deploy RSVP app
kubectl apply -n $NAMESPACE -f manifests/rsvp-deployment.yaml
kubectl apply -n $NAMESPACE -f manifests/rsvp-service.yaml
kubectl apply -n $NAMESPACE -f manifests/rsvp-ingress.yaml

echo "RSVP microservice deployed to EKS."
