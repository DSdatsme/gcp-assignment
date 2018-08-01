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
gcloud container --project "$PROJECTNAME" clusters create $myKube --zone "$myZone" --cluster-version "1.9.7-gke.3" --machine-type "n1-standard-1" --image-type "COS" --no-enable-autoupgrade --enable-autorepair --network "$myVpc" --subnetwork "mySubnet" --labels "name"="$name" --disk-size "100" --enable-autoscaling --min-nodes "2" --max-nodes "4"

#connect to kuvectl
gcloud container clusters get-credentials $myKube --zone "$myZone" --project "$PROJECTNAME"
#run image
kubectl run hello-server --image gcr.io/google-samples/hello-app:1.0 --port 8080
#deploy the image and expose to port 3000
kubectl expose deployment hello-server --type LoadBalancer --port 3000 --target-port 8080