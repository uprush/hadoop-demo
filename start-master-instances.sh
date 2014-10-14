#!/bin/bash
#
# Start the EC2 isntance for Hadoop master.
#

DEMO_HOME=`dirname $0`
DEMO_HOME=`cd $DEMO_HOME; pwd`

source $DEMO_HOME/conf/env.sh

# start instance
aws ec2 run-instances \
--image-id $AMI_ID \
--key-name $KEY_NAME \
--security-groups $MASTER_SECURITY_GROUP \
--instance-type $MASTER_INSTANCE_TYPE \
--iam-instance-profile Name=$IAM_PROFILE \
--count 1  \
| awk '/InstanceId/{print $2}' \
| grep -o 'i-[^"]*' > /tmp/$MASTER_INSTANCE_NAME

# name the instance
INSTANCE_ID=`cat /tmp/$MASTER_INSTANCE_NAME`
aws ec2 create-tags --resources $INSTANCE_ID --tags Key=Name,Value=$MASTER_INSTANCE_NAME

echo "Starting ${INSTANCE_NAME}, instance_id: ${INSTANCE_ID}"

# wait for instance to be ready
# aws ec2 describe-instance-status --instance-id $INSTANCE_ID
sleep 2

# Note master private FQDN
rm -f $DEMO_HOME/conf/cluster/masters
mkdir -p $DEMO_HOME/conf/cluster

aws ec2 describe-instances \
--instance-id $INSTANCE_ID \
| awk '/PrivateDnsName/{print $2}' \
| head -1 | grep -o 'ip-[^"]*' > $DEMO_HOME/conf/cluster/masters

cp $DEMO_HOME/conf/cluster/masters $DEMO_HOME/conf/cluster/all_nodes

echo "Master private FQDN: `cat $DEMO_HOME/conf/cluster/masters`"


# Get master public FQDN to view hadoop web ui
# aws ec2 describe-instances \
# --instance-id i-3cde4c25 \
# | awk '/PublicDnsName/{print $2}' \
# | head -1 | grep -o 'ec2-[^"]*' > $DEMO_HOME/conf/master-public
# echo
# echo "Master public FQDN: `cat $DEMO_HOME/conf/master-public`"

