echo "connecting to the correct cluster"
aws eks update-kubeconfig --name firstcluster --region us-east-1
kubectl get nodes

echo "uninstall ingress nginx and cert-manager completed"
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/aws/deploy.yaml
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.0/cert-manager.yaml

kubectl apply -f ../k8s

kubectl get services