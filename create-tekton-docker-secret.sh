#!/bin/bash

echo "Creating Docker registry secret, patching it to use the annotation and then patching the default service account."
echo "This script requires changes to use your own credentials!"

kubectl create secret docker-registry registry-secret \
  --docker-server https://index.docker.io/v1/ \
  --docker-username myuser \
  --docker-password mypass \
  --docker-email myemail \
  --namespace default

  kubectl patch secret registry-secret -p='{"metadata":{"annotations": {"tekton.dev/docker-0": "https://index.docker.io/v1/"}}}' \
  --namespace default

kubectl patch sa default -n default \
  --type=json \
  -p="[{\"op\":\"add\",\"path\":\"/secrets/0\",\"value\":{\"name\": \"registry-secret\"}}]"