My Hadoop Demo
==============

This is to demostrate how to install the hadoop eco-system on EC2.

Pre-requisites
--------------
* 64-bit Ubuntu Precise (12.04)
* AWS account to start EC2 / RDS instances


Demostrations
-------------

# Set up bastion server
All the demostrations are operated on the bastion server. An t2.micro EC2 instance is fine.

Bootstrap the bastion server.

    $ ./bootstrap-bastion.sh

# Demo Command Usages

    Usage: ./hdemo [-c command] [-s subcommand] [-e command]

    -c command [-s subcommand]: run command on specific nodes
    Supported commands
      start-master-instances: start EC2 instances for hadoop masters
      start-slave-instances: start EC2 instances for hadoop slaves
      start-metastore: start RDS instance for HCatalog/Hive metastore
      check_reachabilities: check reachability for all nodes
      pre-setup: prepare for hadoop setup, runs on all nodes
      setup-masters: set up hadoop masters
      setup-slaves: set up hadoop slaves
      setup-jobhistory: set up YARN job history server
      setup-hive: set up Hive and HCatalog
      namenode: format / start / stop namenode
      datanode: start / stop datanode
      yarn_rm: start / stop YARN resource manager
      yarn_nm: start / stop YARN node manager
      jobhistory: start / stop YARN job history
      hive_server: start / stop Hive server2
      tweets: Hive example to copy / create / load / query tweets table

    -e command: run adhoc command on all nodes


# Step by Step Demostration Manual
All the following operations are done on the bastion server.

    # Start EC2 / RDS instances
    $ cd hadoop-demo
    $ ./hdemo -c start-master-instances
    $ ./hdemo -c start-slave-instances
    $ ./hdemo -c start-metastore

    # Edit environment variables in conf/env.sh
    $ vi conf/env.sh

    # Set up Hadoop core on EC2
    $ ./hdemo -c check_reachabilities
    $ ./hdemo -c pre-setup
    $ ./hdemo -c setup-masters
    $ ./hdemo -c setup-slaves

    # Start HDFS and YARN
    $ ./hdemo -c namenode -s format
    $ ./hdemo -c namenode -s start
    $ ./hdemo -c datanode -s start
    $ ./hdemo -c yarn_rm -s start
    $ ./hdemo -c yarn_nm -s start

    # (Optional, not well tested) Set up and start YARN job history server
    $ ./hdemo -c setup-jobhistory
    $ ./hdemo -c jobhistory -s start

    # Set up Hive
    $ ./hdemo -c setup-hive

    # (Optional, WIP) Start Hiveserver2
    $ ./hdemo -c hive_server -s start

    # Run a simple demo to copy JSON tweets data to HDFS, create Hive table and load tweets data into the table,
    # and query the data in Hive.
    $ ./hdemo -c tweets -s copy
    $ ./hdemo -c tweets -s create
    $ ./hdemo -c tweets -s load
    $ ./hdemo -c tweets -s query

Enjoy Hadoop!
