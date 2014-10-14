#!/bin/bash

DEMO_HOME=`dirname $0`
DEMO_HOME=`cd $DEMO_HOME; pwd`

source $DEMO_HOME/conf/env.sh
source $DEMO_HOME/hdp_helper/scripts/directories.sh
source $DEMO_HOME/hdp_helper/scripts/usersAndGroups.sh

function setup_common() {
  apt-get update -y
  setup_open_jdk
  config_repo

  # install dependencies and utilities
  apt-get install -y chkconfig

  # install hadoop packages
  apt-get install -y hadoop hadoop-hdfs libhdfs0 libhdfs0-dev hadoop-yarn hadoop-mapreduce hadoop-client openssl

  # install Snappy and LZO
  apt-get install -y libsnappy1 libsnappy-dev
  ln -sf /usr/lib64/libsnappy.so /usr/lib/hadoop/lib/native/.

  apt-get install -y liblzo2-2 liblzo2-dev hadoop-lzo
}

function setup_open_jdk() {
  apt-get install -y openjdk-7-jdk
  mkdir /usr/java
  ln -s /usr/lib/jvm/java-7-openjdk-amd64 /usr/java/default
  rm /usr/bin/java
  ln -s /usr/java/default/bin/java /usr/bin/java

  export JAVA_HOME=/usr/java/default
  export PATH=$JAVA_HOME/bin:$PATH

  echo "Using Java:"
  java -version
}

function config_repo() {
  wget $HDP_REPO -O /etc/apt/sources.list.d/hdp.list
  gpg --keyserver pgp.mit.edu --recv-keys B9733A7A07513CAD
  gpg -a --export 07513CAD | apt-key add -
  apt-get update -y
}

function create_common_directories() {
  # YARN local directory
  mkdir -p $YARN_LOCAL_DIR;
  chown -R $YARN_USER:$HADOOP_GROUP $YARN_LOCAL_DIR;
  chmod -R 755 $YARN_LOCAL_DIR;

  # YARN local log directories
  mkdir -p $YARN_LOCAL_LOG_DIR;
  chown -R $YARN_USER:$HADOOP_GROUP $YARN_LOCAL_LOG_DIR;
  chmod -R 755 $YARN_LOCAL_LOG_DIR;

  # HDFS log directory
  mkdir -p $HDFS_LOG_DIR;
  chown -R $HDFS_USER:$HADOOP_GROUP $HDFS_LOG_DIR;
  chmod -R 755 $HDFS_LOG_DIR;

  # YARN log directory
  mkdir -p $YARN_LOG_DIR;
  chown -R $YARN_USER:$HADOOP_GROUP $YARN_LOG_DIR;
  chmod -R 755 $YARN_LOG_DIR;

  # Hadoop pid directory
  mkdir -p $HDFS_PID_DIR;
  chown -R $HDFS_USER:$HADOOP_GROUP $HDFS_PID_DIR;
  chmod -R 755 $HDFS_PID_DIR

  # YARN pid directory
  mkdir -p $YARN_PID_DIR;
  chown -R $YARN_USER:$HADOOP_GROUP $YARN_PID_DIR;
  chmod -R 755 $YARN_PID_DIR;

  # MapReduce log directory
  mkdir -p $MAPRED_LOG_DIR;
  chown -R $MAPRED_USER:$HADOOP_GROUP $MAPRED_LOG_DIR;
  chmod -R 755 $MAPRED_LOG_DIR;

  # MapReduce pid directory
  mkdir -p $MAPRED_PID_DIR;
  chown -R $MAPRED_USER:$HADOOP_GROUP $MAPRED_PID_DIR;
  chmod -R 755 $MAPRED_PID_DIR;
}

# Configure core hadoop
function configure_core_hadoop() {
  HELPER_CONF_DIR=$DEMO_HOME/hdp_helper/configuration_files/core_hadoop

  # core-site.xml
  MASTER_HOSTNAME=`cat $DEMO_HOME/conf/cluster/masters`
  sed -i "s/TODO-NAMENODE-HOSTNAME:PORT/$MASTER_HOSTNAME:8020/g" $HELPER_CONF_DIR/core-site.xml

  # hdfs-site.xml
  sed -i "s/TODO-DFS-DATA-DIR/$LIST_OF_DATA_DIRS/g" $HELPER_CONF_DIR/hdfs-site.xml
  sed -i "s/TODO-NAMENODE-HOSTNAME/$MASTER_HOSTNAME/g" $HELPER_CONF_DIR/hdfs-site.xml
  sed -i "s/TODO-DFS-NAME-DIR/$LIST_OF_NAMENODE_DIRS/g" $HELPER_CONF_DIR/hdfs-site.xml

  # yarn-site.xml
  sed -i "s/TODO-RESOURCEMANAGERNODE-HOSTNAME/$MASTER_HOSTNAME/g" $HELPER_CONF_DIR/yarn-site.xml
  sed -i "s/--- Secure cluster/Secure cluster/g" $HELPER_CONF_DIR/yarn-site.xml # fix error xml syntax. bug?
  sed -i "s/\/hadoop\/yarn\/local/$LIST_OF_YARN_LOCAL_DIRS/g" $HELPER_CONF_DIR/yarn-site.xml
  sed -i "s/\/hadoop\/yarn\/log/$LIST_OF_YARN_LOCAL_LOG_DIRS/g" $HELPER_CONF_DIR/yarn-site.xml

  # mapred-site.xml
  sed -i "s/TODO-JOBHISTORYNODE-HOSTNAME/$MASTER_HOSTNAME/g" $HELPER_CONF_DIR/mapred-site.xml

  # (Optional) compression

  # (Optional) memory settings

  # copy settings
  rm -rf $HADOOP_CONF_DIR
  mkdir -p $HADOOP_CONF_DIR

  cp $HELPER_CONF_DIR/* $HADOOP_CONF_DIR

  # set permissions
  chown -R $HDFS_USER:$HADOOP_GROUP $HADOOP_CONF_DIR/../
  chmod -R 755 $HADOOP_CONF_DIR/../
}

