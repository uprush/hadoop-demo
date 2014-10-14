#!/bin/bash
# Environment variables
#

# AWS settings
## Common settings for master and slaves
AMI_ID='ami-f96b40f8'
KEY_NAME='u-bastion'
IAM_PROFILE='hadoop-ec2-default-role'

## Master settings
MASTER_INSTANCE_TYPE='m3.large'
MASTER_INSTANCE_NAME='hadoop-master'
MASTER_SECURITY_GROUP='hadoop-master'

## Slave settings
SLAVE_INSTANCE_TYPE='m3.large'
SLAVE_INSTANCE_NAME='hadoop-slave'
SLAVE_SECURITY_GROUP='hadoop-slave'
SLAVE_NODE_COUNT=2

# HDP settings

## HDFS settings. See hdp_helper/scripts/directories.sh
## Recommended configuration on AWS:
##   - Multiple EBS for NN/SNN directories
##   - Multiple instance stores for DD/YARN directories
##     Number of instance stores depends on EC2 instance size
LIST_OF_NAMENODE_DIRS="\/mnt\/hadoop\/hdfs\/nn"
LIST_OF_DATA_DIRS="\/mnt\/hadoop\/hdfs\/dn"
LIST_OF_YARN_LOCAL_DIRS="\/mnt\/hadoop\/yarn\/local"
LIST_OF_YARN_LOCAL_LOG_DIRS="\/mnt\/hadoop\/yarn\/logs"

## HDP repository
HDP_REPO="http://public-repo-1.hortonworks.com/HDP/ubuntu12/2.1.5.0/hdp.list"

# NTP
LOCAL_NETWORK='172.31.0.0'
NETWORK_MASK='255.255.0.0'
NTP_SERVER='TODO_MASTER_NODE_IP'

# metastore
METASTORE_DB_NAME='TODO_HIVE_DB'
METASTORE_DB_ID='TODO_HIVE-METASTORE'
METASTORE_DB_USER='TODO_HIVE_DBUSER'
METASTORE_DB_PASSWORD='TODO_HIVE_DBPASSWD'
# replace following with RDS endpoint
METASTORE_DB_HOST='TODO_METASTORE_RDS_HOST'
METASTORE_DB_PORT='TODO_METASTORE_RDS_PORT'
METASTORE_DB_DRIVER='com.mysql.jdbc.Driver'

MYSQL_CONNECTOR_URL='TODO_URL_TO_DOWNLOAD_mysql-connector-java-5.1.33-bin.jar'
