# GKE-POC

The below scripts are executed from GCP cloud shell terminal. If you wish to run it from your local machine then you will need to configure
1. gcloud
2. terraform
3. python 
4. kubectl..and any other necessary dependencies.
Also, you will need to authenticate to your gcloud account and set your project config

gke-cluster-create.sh - creates a kubernetes cluster on GKE

run-kube-app.sh - deploys your app via yaml to the GKE cluster.

cleanup-kube-app.sh - Deletes all the objects and resources used by your app from the GKE cluster

gke-cluster-delete.sh - deletes the cluster on GKE and the leftover resources not deleted by GKE (as part of cluster deletion)

Dockerfile - this file has the base image for knoteapp frontend and NodeJs backend. MongoDB is used as the database for storing the details

tfscripts/ - this folder contains all the scripts that will bring up the GKE cluster. You can modify the variables.tf file to add values specific to your project.account.json file is the credentials file for service account being used. You will need to use your own json file.
