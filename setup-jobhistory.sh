#!/bin/bash
#
# (Optional) Set up YARN job history server
#

DEMO_HOME=`dirname $0`
DEMO_HOME=`cd $DEMO_HOME; pwd`

source $DEMO_HOME/functions.sh

# set up directories on HDFS
hadoop fs -mkdir -p /mr-history/tmp
hadoop fs -chmod -R 1777 /mr-history/tmp
hadoop fs -mkdir -p /mr-history/done
hadoop fs -chmod -R 1777 /mr-history/done
hadoop fs -chown -R $MAPRED_USER:$HDFS_USER /mr-history

hadoop fs -mkdir -p /app-logs
hadoop fs -chmod -R 1777 /app-logs
hadoop fs -chown yarn /app-logs

echo "Completed successfully: setup-jobhistory"
