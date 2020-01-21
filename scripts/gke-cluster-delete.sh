read -p "Enter the name of CLUSTER you want to delete : " clustername
read -p "Enter the ZONE where the cluster is created : " czone
read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

gcloud container clusters delete --quiet --zone="$czone" "$clustername"

echo "Showing list of persistent volumes. They are not auto deleted even when cluster is deleted..."
gcloud compute disks list
echo "You can delete PV's manually if needed by using this command -- gcloud compute disks delete --zone=<zone-name> <PV-name>"

#echo "Deleting unused persistent volumes"
#export PERSISTANT_STORAGE=$(kubectl -n dispatch get pv -o json | jq -r '.items[0].spec.gcePersistentDisk.pdName // empty')
#echo "$PERSISTANT_STORAGE"
#gcloud compute disks delete --zone="$czone" --quiet "$PERSISTANT_STORAGE"

echo "Deleting external load balancer related components. They are not auto deleted even when cluster is deleted..."
gcloud beta compute forwarding-rules list | cut -d ' ' -f1 | xargs -I{} gcloud beta compute forwarding-rules delete {} --global
gcloud beta compute target-http-proxies list | cut -d ' ' -f1 | xargs -I{} gcloud beta compute target-http-proxies delete {} --global
gcloud beta compute url-maps list | cut -d ' ' -f1 | xargs -I{} gcloud beta compute url-maps delete {} --global
gcloud beta compute backend-services list | cut -d ' ' -f1 | xargs -I{} gcloud beta compute backend-services delete {} --global
gcloud compute health-checks list | cut -d ' ' -f1 | xargs -I{} gcloud beta compute health-checks delete {}
gcloud compute addresses list | cut -d ' ' -f1 | xargs -I{} gcloud beta compute addresses delete {} --global

echo "Showing list of Firewall rules..."
gcloud compute firewall-rules list
echo "You can delete firewall rules manually if needed by using this command --  gcloud compute firewall-rules delete -q [NAME]"
