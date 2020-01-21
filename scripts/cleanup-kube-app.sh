#!/bin/bash

fwrulename=""
nsname=""
echo "Showing list of NAMESPACES..."
kubectl get namespaces
read -p "Enter SPACE separated list of NAMESPACES (from above list) that you want to delete. <Leave blank in case DEFAULT namespace is used> : " nsname
echo "Showing list of FIREWALL RULES..."
gcloud compute firewall-rules list
read -p "Enter SPACE separated list of FIREWALL RULE NAMES <from above list> that you want to delete. <Leave blank if you want to ignore this step> : " fwrulename
read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

if [[ ! -z "$nsname" ]]
then
echo "Deleting namespaces $nsname and all its components..."
kubectl delete namespace ${nsname[@]}
echo ""
echo "Now showing existing namespaces..."
kubectl get namespaces
else
echo "Since you have not selected any namespace so falling back to delete individual objects from DEFAULT NAMESPACE by cherry-pick method..."
echo "Showing list of DEPLOYMENTS..."
kubectl get deployments
read -p "Please enter SPACE separated names of DEPLOYMENTS (from above list) that you want to delete : " deployname
echo "Showing list of SERVICES..."
kubectl get svc
read -p "Please enter SPACE separated names of SERVICES (from above list) that you want to delete : " svcname
echo ""
echo "The following DEPLOYMENTS will be deleted ${deployname[@]}"
echo "The following SERVICES will be deleted ${svcname[@]}"
read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
kubectl delete deployment ${deployname[@]}
echo ""
kubectl delete svc ${svcname[@]}
fi

echo ""
if [[ ! -z "$fwrulename" ]]
then
echo "Deleting the firewall rules..."
gcloud compute firewall-rules delete -q ${fwrulename[@]}
fi
