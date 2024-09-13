#!/bin/bash
NAMESPACE="argocd"
DEPLOYMENT_NAME="argocd-server"
#create Cluster my-cluster
k3d cluster create my-cluster

###### Check if kubectl is installed ######
if ! command -v kubectl &> /dev/null; then
    echo "###### kubectl is not installed. Please install it and try again. ######"
    exit 1
fi

#create argoCD namespace
echo "###################-create argoCD namespace-#########"
kubectl create namespace argocd || true

#Deploy ArgoCD into  the argoCD namespace
echo "######################-Deploy ArgoCD  into argoCD namespace-##############"
kubectl apply -n ${NAMESPACE} -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

#sleep 1 minute
echo "###################-waiting 1 minute for pods to start-#########"
sleep 1m

#Check if pods are up
kubectl get pods -n argocd
#sleep 1 minute
echo "###################-waiting 1 minute for pods to start-#########"
sleep 1m

#change service type from clusterIp to NodePort
echo "###################-change argoCD service type from clusterIp to NodePort ###################"
kubectl patch service argocd-server -n argocd -p '{"spec": {"type": "NodePort", "ports": [{"port": 80, "targetPort": 8080, "nodePort": 30888}]}}'

# Get ArgoCD admin password 
#sleep 5 minute
echo "###################-waiting 5 minute until the initial secret created-#########"
sleep 5m
echo "###### GET ArgoCD admin password ######"

echo "Username : admin"
kubectl get secret -n ${NAMESPACE} argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d > argocd-init-pass.txt

kubectl create namespace dev || true
kubectl create -n dev -f ../confs/playground-deployment.yaml
# Print a success message 
echo "###### ArgoCD server configuration has been updated successfully. the argocd console Link :"

#run the second script for getting argocd URL
SCRIPT_DIR=$(dirname "$0")
"${SCRIPT_DIR}/argocd-url.sh"