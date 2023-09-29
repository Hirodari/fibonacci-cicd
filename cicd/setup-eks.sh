#!/bin/bash

# just or the sake of testing

curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version

echo "let's create an eks cluster"
eksctl create cluster --name firstcluster --region us-east-1 --nodegroup-name eksgroup --node-type t2.small --nodes 2
echo "done"
# aws eks update-kubeconfig --name firstcluster --region us-east-1