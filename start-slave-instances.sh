#!/bin/bash
#
# Start the EC2 isntances for Hadoop slaves.
#

DEMO_HOME=`dirname $0`
DEMO_HOME=`cd $DEMO_HOME; pwd`

source $DEMO_HOME/conf/env.sh

# start instance
aws ec2 run-instances \
--image-id $AMI_ID \
--key-name $KEY_NAME \
--security-groups $SLAVE_SECURITY_GROUP \
--instance-type $SLAVE_INSTANCE_TYPE \
--iam-instance-profile Name=$IAM_PROFILE \
--count $SLAVE_NODE_COUNT  \
| awk '/InstanceId/{print $2}' \
| grep -o 'i-[^"]*' > /tmp/$SLAVE_INSTANCE_NAME

# name the instance
COUNTER=1
for INSTANCE_ID in `cat /tmp/$SLAVE_INSTANCE_NAME`
do
  aws ec2 create-tags --resources $INSTANCE_ID --tags Key=Name,Value="${SLAVE_INSTANCE_NAME}-${COUNTER}"
  echo "Starting ${SLAVE_INSTANCE_NAME}-${COUNTER}, instance_id: ${INSTANCE_ID}"
  COUNTER=$((COUNTER + 1))
done

# wait for instance to be ready
# aws ec2 describe-instance-status --instance-id $INSTANCE_ID
sleep 2

# Note private FQDN
rm -f $DEMO_HOME/conf/cluster/slaves
for INSTANCE_ID in `cat /tmp/$SLAVE_INSTANCE_NAME`
do
  aws ec2 describe-instances \
  --instance-id $INSTANCE_ID \
  | awk '/PrivateDnsName/{print $2}' \
  | head -1 | grep -o 'ip-[^"]*' >> $DEMO_HOME/conf/cluster/slaves
done
cat $DEMO_HOME/conf/cluster/slaves >> $DEMO_HOME/conf/cluster/all_nodes

echo "Slaves private FQDNs:"
cat $DEMO_HOME/conf/cluster/slaves
