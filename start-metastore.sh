#!/bin/bash
#
# Start an RDS instance as the metastore database of HCatalog/Hive
#

DEMO_HOME=`dirname $0`
DEMO_HOME=`cd $DEMO_HOME; pwd`

source $DEMO_HOME/conf/env.sh

aws rds create-db-instance \
--db-name $METASTORE_DB_NAME \
--db-instance-identifier $METASTORE_DB_ID \
--allocated-storage 5 \
--db-instance-class db.t2.small \
--engine MySQL \
--master-username $METASTORE_DB_USER \
--master-user-password $METASTORE_DB_PASSWORD
