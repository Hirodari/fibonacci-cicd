#!/bin/bash

# just or the sake of testing

echo "let's create an eks cluster"
eksctl create cluster --name firstcluster --region us-east-1 --nodegroup-name eksgroup --node-type t2.small --nodes 2
echo "done"
aws eks update-kubeconfig --name firstcluster --region us-east-1