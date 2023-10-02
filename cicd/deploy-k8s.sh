#!/bin/bash

# fail on any error
set -eu

echo "deploy terraform"

pwd
cd ../iac/terraform-infrastructure
terraform init
terraform destroy --auto-approve

# echo "connecting to the correct cluster"
# aws eks update-kubeconfig --name firstcluster --region us-east-1
# kubectl get nodes

# kubectl apply -f ../../k8s/

# echo "ingress nginx and cert-manager completed"
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/aws/deploy.yaml
# kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.0/cert-manager.yaml

# exit 0
# kubectl get services

