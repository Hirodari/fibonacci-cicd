#!/bin/bash

echo "connect to aws eks cluster"
aws eks update-kubeconfig --name ekslearningcluster --region us-east-1

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/aws/deploy
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.0/cert-manager.yaml

echo "ingress nginx and cert-manager completed"