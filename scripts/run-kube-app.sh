#!/bin/bash

fwrulename=""
nportnum=""
nsname=""
read -p "Enter your DEPLOYMENT YAML file name (Ex.knote-complete.yaml) : " deployfile
read -p "Enter the NAMESPACE name used by your deployment (Ex. knoteapp). Leave blank if you want to create in DEFAULT NAMESPACE : " nsname
read -p "Enter the FIREWALL RULE name for your app (Ex. knote-node-port). Leave blank in case Load Balancer Service is used instead of NodePort : " fwrulename
read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

#Create Namespace
if [[ ! -z "$nsname" ]]
then
echo "Creating namespace..."
kubectl create namespace "$nsname"
fi

echo ""

#Create deployments and services
echo "Applying YAML file to create deployments and Services..."
kubectl apply -f "$deployfile"

echo ""

#Check  the status of pods
if [[ ! -z "$nsname" ]]
then
echo "Checking the status of Pods..."
for homepod in `kubectl get pods -n $nsname --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}'`;
do
while [[ $(kubectl get pods $homepod -n $nsname -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]];
do echo "waiting for pod $homepod to start..." && sleep 5;
done
echo "Pod $homepod is running now"
done
else
echo "Checking the status of Pods..."
for homepod in `kubectl get pods --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}'`;
do
while [[ $(kubectl get pods $homepod -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]];
do echo "waiting for pod $homepod to start..." && sleep 5;
done
echo "Pod $homepod is running now"
done
fi

echo ""

#check if all services are created successfully
if [[ ! -z "$nsname" ]]
then
echo "Checking if all Services are up and running..."
kubectl get svc -n "$nsname"
read -p "Enter the NODEPORT PORT number for your app (from above list). Leave blank in case Load Balancer Service is used instead of NodePort : " nportnum
else
echo "Checking if all Services are up and running..."
kubectl get svc
read -p "Enter the NODEPORT PORT number for your app (from above list). Leave blank in case Load Balancer Service is used instead of NodePort : " nportnum
fi

echo ""

#check if persistent volume is created and mounted successfully
echo "Checking if Persistent Volumes and Persistent Volume Claims are created successfully..."
kubectl get pv
echo ""
if [[ ! -z "$nsname" ]]
then
kubectl get pvc -n "$nsname"
else
kubectl get pvc
fi

echo ""

if [[ ! -z "$fwrulename" ]]
then
echo "Opening port $nportnum by creating firewall rule to make the app accessible from external network"
gcloud compute firewall-rules create "$fwrulename" --allow tcp:"$nportnum"
echo ""
echo "Getting the external IP of the node..."
extip=$(kubectl get nodes -o json | jq -r .items[0].status.addresses[1].address)
echo "External IP of node is - $extip"
echo ""
echo "To access the app please click this URL - http://$extip:$nportnum"
echo "External IP can be found from below..."
kubectl get nodes -o wide
else
echo "Please wait for Load Balancer to populate the external-ip address for your app..."
echo "To access the app please use external ip address along with the port number as shown below..."
echo ""
sleep 5
if [[ ! -z "$nsname" ]]
then
echo "Press CTRL+C to exit the watch option..."
sleep 5
watch kubectl get svc -n "$nsname"
else
echo "Press CTRL+C to exit the watch option..."
sleep 5
watch kubectl get svc
fi
fi
