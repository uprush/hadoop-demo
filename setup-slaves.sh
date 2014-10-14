#!/bin/bash

DEMO_HOME=`dirname $0`
DEMO_HOME=`cd $DEMO_HOME; pwd`

source $DEMO_HOME/functions.sh

# NTP server
function setup_ntp_client() {
  # Configure /etc/ntp.conf
  apt-get install -y ntp

  sed -e "s/TODO_NTP_SERVER/$NTP_SERVER/g" $DEMO_HOME/conf/ntp/ntp.conf.client > /tmp/ntp.conf.client
  cp /tmp/ntp.conf.client /etc/ntp.conf

  chkconfig ntp on
  /etc/init.d/ntp restart
}

# Create directories
function create_slave_directories() {
  # Datanode directories
  mkdir -p $DFS_DATA_DIR;
  chown -R $HDFS_USER:$HADOOP_GROUP $DFS_DATA_DIR;
  chmod -R 750 $DFS_DATA_DIR;
}

setup_common
setup_ntp_client
create_common_directories
create_slave_directories
configure_core_hadoop

echo "Completed successfully: setup-slaves"
