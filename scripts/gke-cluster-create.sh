#!/bin/bash

read -p "Enter your gcloud PROJECT ID (Ex.tranquil-buffer-264907) : " projectid
gcloud config set project "$projectid"

read -p "Enter the CLUSTER name (Ex. knoteapp) : " clusterid

read -p "Enter the number of NODES needed in your cluster (Ex. 2) : " nodesnum

read -p "Enter the MACHINE TYPE for your cluster nodes (Ex. g1-small, n1-standard-1) : " machineid

read -p "Enter the ZONE where your machines will be hosted (Ex. us-central1-a, us-central1-b) : " zonename

read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

echo "Creating cluster as per the info provided by you..."
gcloud container clusters create "$clusterid" --num-nodes="$nodesnum" --machine-type="$machineid" --zone="$zonename" --enable-ip-alias --project="$projectid"
