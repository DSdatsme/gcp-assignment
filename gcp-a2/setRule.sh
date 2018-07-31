echo "insert a bucket name"
read myBucket
gsutil lifecycle set rule.json gs://${myBucket}
#gsutil lifecycle get gs://${myBucket}
echo "Lifecycle sucessfully set"