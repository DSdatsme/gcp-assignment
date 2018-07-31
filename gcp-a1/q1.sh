#question 1
PROJECTNAME="pe-training"
echo "enter a VPC name"
read myVpcName
echo "creating vpc in auto mode....."
gcloud compute --project="$PROJECTNAME" networks create "$myVpcName"
echo "attaching a firewall to vpc....."
gcloud compute firewall-rules create darshit-firewallzz --action allow --rules tcp:22 --source-ranges 59.152.52.0/22 --direction ingress --network "$myVpcName"