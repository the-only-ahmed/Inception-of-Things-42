#!/bin/bash


# Get the NodePort of the argocd-server service
NODE_PORT=$(kubectl get svc argocd-server -n argocd -o jsonpath='{.spec.ports[0].nodePort}')

# Get the IP address of the K3s node
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')

# Construct the URL
ARGOCD_URL="http://${NODE_IP}:${NODE_PORT}"

# Output the URL
echo "ArgoCD URL: ${ARGOCD_URL}"

