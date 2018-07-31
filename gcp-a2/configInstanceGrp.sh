my-project="pe-training"
echo "Enter instance template name"
read my-template
echo "Enter instange group name"
read instanceGrpName
#echo "specify the template you want to use"
#read myTemplate
echo "Enter health check name"
read mycheck
echo "Minimum replicas?"
read minReplicas
echo "Max replicas?"
read maxReplicas
echo "enter backend service name"
read backendServiceName
echo "Enter loadbalancer name"
read myLoadBalancer

#create instance template
echo "creating template....."
gcloud compute instance-templates create "$my-template" --machine-type=n1-standard-1 --project="$my-project" --network=projects/pe-training/global/networks/default --service-account=912623308461-compute@developer.gserviceaccount.com --image=debian-9-stretch-v20180716 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard

#create instance group
echo "creating instance group....."
gcloud compute --project "$my-project" instance-groups managed create "$instanceGrpName" --base-instance-name "$instanceGrpName" --template "$myTemplate" --size "1" --zone "us-central1-c"
echo "configuring auto scaling....."
gcloud compute --project "$my-project" instance-groups managed set-autoscaling "$instanceGrpName" --zone "us-central1-c" --cool-down-period "60" --max-num-replicas "$maxReplicas" --min-num-replicas "$minReplicas" --target-cpu-utilization "0.6"

#for health checks
echo "creating health check....."
gcloud compute http-health-checks create  "$mycheck" --port "80" --request-path "/" --check-interval "5" --timeout "5" --project "pe-training"

#for load balancer
#create backend
gcloud compute backend-services create "$backendServiceName" --http-health-checks "$mycheck" --global
#add health check to backend
gcloud compute backend-services add-backend "$backendServiceName" --instance-group "$instanceGrpName"
#attach loadbalancer to backend
gcloud compute url-maps create "$myLoadBalancer" --default-service "$backendServiceName"