#question3
echo "enter a VPC name"
read myVpcName
gcloud compute --project=pe-training networks create "$myVpcName" --subnet-mode=custom

echo "Enter a region code for first subnet Eg: us-east1"
read region1
echo "Enter CIDR range for subnet1 Eg: 10.0.0.0/22"
read cidrReg1
echo "Enter a region code for second subnet Eg: us-central1"
read region2
echo "Enter CIDR range for subnet2 Eg: 10.0.0.0/22"
read cidrReg2
echo "Enter a name for nat "
read natInstance
echo "Enter a name for private instance"
read privateInstance

echo "Creating custom subnets....."
gcloud compute --project=pe-training networks subnets create ${myVpcName}1 --network="$myVpcName" --region=$region1 --range="$cidrReg1" --enable-flow-logs
gcloud compute --project=pe-training networks subnets create ${myVpcName}2 --network="$myVpcName" --region=$region2 --range="$cidrReg2" --enable-private-ip-google-access

echo "Creating firewall rules....."
#firewall to allow ssh
gcloud compute firewall-rules create all-ssh-firewall-rule --allow tcp:22 --network="$myVpcName"
#firewall to allow internal communication
gcloud compute firewall-rules create allow-internat-firewall-rule --allow icmp,tcp:1-65535,udp:1-65535 --source-ranges 10.0.0.0/16 --network="$myVpcName"

#creating NAT instance
echo "Launching NAT ....."
gcloud compute instances create $natInstance --network="$myVpcName" --can-ip-forward --zone "$region1" --image-family debian-8 --subnet ${myVpcName}1 --image-project debian-cloud --tags my-nat-gateway --metadata=startup-script="sudo sysctl -w net.ipv4.ip_forward=1\nsudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE"

#creating private instance
echo "Launching private instance....."
gcloud compute instances create $privateInstance --network "$myVpcName" --no-address --zone "$region2" --image-family debian-8 --subnet ${myVpcName}2 --image-project debian-cloud --tags private-instance

#creating route to internet
gcloud compute routes create private-access-route --network "$myVpcName" --destination-range 0.0.0.0/0 --next-hop-instance my-nat-gateway --next-hop-instance-zone ${myVpcName}1 --tags private-instance --priority 900

