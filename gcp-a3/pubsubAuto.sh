echo "Enter topic name"
read pubsubTopicName
PROJECTNAME="pe-training"
echo "Enter name of function"
read function_name

echo "Creating topic....."
gcloud pubsub topics create "$pubsubTopicName" 

git clone https://github.com/DSdatsme/pubsubcode
#gcloud functions deploy darshit_f --source https://github.com/DSdatsme/GCP_P-SandCloudFunction/blob/master/deploy.py --trigger-http
#gcloud beta functions --project="pe-training" deploy "DarshitKa" --entry-point "./pubsubcode" --memory=256MB --trigger-resource "mytop" --trigger-event google.pubsub.topic.publish
cd pubsubcode/code
echo "creating cloud function, please wait for some time....."
gcloud beta functions --project="$PROJECTNAME" deploy "$function_name" --entry-point "hello_pubsub" --runtime python37 --memory=128MB --trigger-resource "$pubsubTopicName" --trigger-event google.pubsub.topic.publish

cd ..
readfile=`cat mymessage.json`

gcloud pubsub topics publish "$pubsubTopicName" --message "$readfile"