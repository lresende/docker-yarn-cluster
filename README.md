#Apache Yarn 2.7.1 cluster Docker image

# Build the image

If you'd like to try directly from the Dockerfile you can build the image as:

```
sudo docker build  -t yarn-cluster .
```

# Start an Apache Yarn namenode container

In order to use the Docker image you have just build or pulled use:

```
sudo docker run -i -t --name namenode -h namenode yarn-cluster /etc/bootstrap.sh -bash -namenode
```

You should now be able to access the Hadoop Admin UI at

http://<host>:8088/cluster

**Make sure that SELinux is disabled on the host. If you are using boot2docker you don't need to do anything.**

# Start an Apache Yarn datanode container

In order to add data nodes to the Apache Yarn cluster, use:

```
sudo docker run -i -t --link namenode:namenode --dns=namenode yarn-cluster /etc/bootstrap.sh -bash -datanode
```

You should now be able to access the HDFS Admin UI at

http://<host>:50070

**Make sure that SELinux is disabled on the host. If you are using boot2docker you don't need to do anything.**

## Testing

You can run one of the stock examples:

```
cd $HADOOP_PREFIX

# add input files
bin/hdfs dfs -mkdir -p /user/root
bin/hdfs dfs -put $HADOOP_PREFIX/etc/hadoop/ input

# run the mapreduce
bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.1.jar grep input output 'dfs[a-z.]+'

# check the output
bin/hdfs dfs -cat output/*
```

# Start Apache Yarn namenode and datanode container by using docker-compose

```
sudo docker-compose -f docker-compose up -d
```
