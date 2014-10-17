package com.uprush.hdemo;

import backtype.storm.Config;
import backtype.storm.LocalCluster;
import backtype.storm.topology.TopologyBuilder;
import backtype.storm.utils.Utils;

/**
 * Hello world!
 * 
 */
public class HelloStorm {
	public static void main(String[] args) {
		TopologyBuilder builder = new TopologyBuilder();

		builder.setSpout("dummy", new HelloStormSpout());
		builder.setBolt("print", new HelloStormBolt()).shuffleGrouping("dummy");

		Config conf = new Config();

		LocalCluster cluster = new LocalCluster();

		cluster.submitTopology("hellostorm", conf, builder.createTopology());

		Utils.sleep(10000);
		cluster.shutdown();

	}
}
