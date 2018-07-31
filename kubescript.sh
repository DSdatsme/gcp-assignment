PROJECTNAME="pe-training"
echo "Enter a name for cluster"
read myKube
echo "Enter a zone"
read myZone
echo "Enter a VPC in which you want to create clusters, or type default"
read myVpc
echo "Enter a VPC in which you want to create clusters, or type default"
read mySubnet
echo "Enter your name for lable"
read name
gcloud container --project "pe-training" clusters create $myKube --zone "$myZone" --cluster-version "1.9.7-gke.3" --machine-type "n1-standard-1" --image-type "COS" --no-enable-autoupgrade --enable-autorepair --network "$myVpc" --subnetwork "mySubnet" --labels "name"="$name"
 #--username "admin" --clust  --disk-type "pd-standard" --disk-size "100"  --num-nodes "3" --enable-cloud-logging --enable-cloud-monitoring --network "default" --subnetwork "default" --addons HorizontalPodAutoscaling,HttpLoadBalancing,KubernetesDashboard




#gcloud container --project "pe-training" clusters create mykube --zone "us-central1-a" --cluster-version "1.9.7-gke.3" --machine-type "n1-standard-1" --image-type "COS" --no-enable-autoupgrade --enable-autorepair --network "default" --subnetwork "default"
