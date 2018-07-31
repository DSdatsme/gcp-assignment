#question2
#question 1
echo "enter a VPC name"
read myVpcName
echo "Creating a custom mode VPC"
gcloud compute --project=pe-training networks create "$myVpcName" --subnet-mode=custom
echo "Enter a region code for first subnet Eg: us-east1"
read region1
echo "Enter CIDR range for subnet1 Eg: 10.0.0.0/22"
read cidrReg1
echo "Enter a region code for second subnet Eg: us-central1"
read region2
echo "Enter CIDR range for subnet2 Eg: 10.0.0.0/22"
read cidrReg2
echo "Creating custom subnets....."
gcloud compute --project=pe-training networks subnets create ${myVpcName}1 --network="$myVpcName" --region=$region1 --range="$cidrReg1" --enable-flow-logs
gcloud compute --project=pe-training networks subnets create ${myVpcName}2 --network="$myVpcName" --region=$region2 --range="$cidrReg2" --enable-private-ip-google-access
echo "Subnets sucessfully created."