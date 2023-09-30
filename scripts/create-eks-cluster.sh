#!/bin/bash

echo "create eks cluster"

eksctl create cluster --name ekslearningcluster --region us-east-1 --nodegroup-name eksgroup \
--node-type t2.small --nodes 2