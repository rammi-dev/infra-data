#!/bin/bash

# Set the namespace for metrics-server
NAMESPACE=kube-system

# Install the metrics-server
echo "Installing metrics-server with --kubelet-insecure-tls flag..."

kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.6.1/components.yaml

# Wait for metrics-server to be deployed
echo "Waiting for metrics-server pods to be deployed..."
kubectl wait --for=condition=available --timeout=120s deployment/metrics-server -n $NAMESPACE

# Edit the metrics-server deployment to add the --kubelet-insecure-tls flag
echo "Adding --kubelet-insecure-tls flag to metrics-server deployment..."
kubectl patch deployment metrics-server -n $NAMESPACE \
  --patch '{"spec": {"template": {"spec": {"containers": [{"name": "metrics-server", "args": ["--kubelet-insecure-tls"]}]}}}}'

# Verify the metrics-server deployment
echo "Verifying metrics-server pod status..."
kubectl get pods -n $NAMESPACE -l "k8s-app=metrics-server"

echo "Metrics-server installation completed with --kubelet-insecure-tls flag."