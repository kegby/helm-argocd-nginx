#!/bin/bash

# retrieve the access credentials for your cluster and automatically configure kubectl
gcloud container clusters get-credentials $(terraform output -raw kubernetes_cluster_name) --region $(terraform output -raw region)

# This will create a new namespace, argocd, where Argo CD services and application resources will live.
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
sleep 15

# Change the argocd-server service type to LoadBalancer:
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# All Previous file tested and succesfull

# ------ Untested from now on ----->
# Launch Argocd App
kubectl apply -f argocd-nginx.yaml
kubectl apply -f argo-nginx-staging.yaml
kubectl apply -f argo-nginx-prod.yaml

sleep 80

# Display Info to enter Argocd Server
kubectl get services -n argocd
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
# Check External Ip From Load Balancer Service. Open Browser, enter Ip.
# Advanced config and proceed. Username = admin. Password = kubectl -n argocd get secret Output


# Next Would be commands to download argocd , login and autosing. 
# At this time will be done manually. 
# To install argocd it is complicated as first have to download brew. Then complete a couple of commands that takes long.