#!/bin/bash

DEMO_HOME=`dirname $0`
DEMO_HOME=`cd $DEMO_HOME; pwd`

source $DEMO_HOME/functions.sh

# NTP server
function setup_ntp_server() {
  apt-get install -y ntp

  # Configure /etc/ntp.conf
  sed -e "s/TODO_LOCAL_NETWORK/$LOCAL_NETWORK/g;s/TODO_NETWORK_MASK/$NETWORK_MASK/g" $DEMO_HOME/conf/ntp/ntp.conf.server > /tmp/ntp.conf.server
  cp /tmp/ntp.conf.server /etc/ntp.conf

  chkconfig ntp on
  /etc/init.d/ntp restart
}

# Create directories
function create_master_directories() {
  # NN directories
  mkdir -p $DFS_NAME_DIR;
  chown -R $HDFS_USER:$HADOOP_GROUP $DFS_NAME_DIR;
  chmod -R 755 $DFS_NAME_DIR;
}

setup_common
setup_ntp_server
create_common_directories
create_master_directories
configure_core_hadoop

echo "Completed successfully: setup-masters"
