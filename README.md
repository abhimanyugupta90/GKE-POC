# knoteappdemo

gke-cluster-create.sh - creates a kubernetes cluster using GKE

run-knote.sh - deploys the a simple note taking app on the kubernetes cluster.

cleanup-knote.sh - deletes all the objects created for knoteapp

gke-cluster-delete.sh - deletes the cluster and the leftover resources not deleted by GKE (as part of cluster deletion)

Dockerfile - this file has the base image for knoteapp frontend and NodeJs backend. MongoDB is used as the database for stoting the details
