# Apache Yarn 2.7.4 cluster Docker image

### Notes:
This repo is forked from [lresende/docker-yarn-cluster](https://github.com/lresende/docker-yarn-cluster) and updated to make it run without bugs on my MacBook. I made these changes:

*   Update Java 8 and hadoop 2.7.4 download urls, original urls are invalid.
*   Update `bootstrap.sh`, we don't need to run `start-dfs.sh` and `start-yarn.sh` in slaves. As long as the master node knows the slaves, `start-dfs.sh` and `start-yarn.sh` will be able to start `Namenode` and `ResourceManager` on master node, with `Datanode` and `NodeManager` on each slave node. Ref: [this post](https://www.edureka.co/blog/hadoop-cluster-configuration-files/).
*   Use `docker-compose.yml` configuration file. One big issue is how to make the containers know each other. By `know` I mean hadoop and yarn knows each container's ip address. So I create a custom network, set a static ip address for each container in the network, and with `extra_hosts`, the host-to-ip mappings are added to each container's `etc/hostname`.
*   Add `wordcount.sh` to verify the cluster is set up correctly.

### Build the image

*   build the image with tag `yarn-cluster`:

```
    ./build
```

### Start the cluster by using `docker-compose`
```
    docker-compose up
```
*   the cluster will have a `namenode` container as master, and `datanode1`, `datanode2` and `datanode3` containers as slaves.

*   ssh into namenode: `docker exec -it namenode sh` and run `jps`, it will show:

```
    561 Jps
    489 ResourceManager
    125 NameNode
    333 SecondaryNameNode
```
*   ssh into any datanode, for example datanode1: `docker exec -it datanode1 sh` and run `jps`, it will show:

```
    48 DataNode
    152 NodeManager
    285 Jps
```

## Testing
*   ssh into any container, for example: `docker exec -it datanode3 sh`, and run `./wordcount.sh`, it will eventually comes up with this output:

```
    Docker  2
    Hadoop  1
    Hello   3
    World   1
    in  1
```

## Resize cluster's datanodes
*   To add or remove datanodes, we only need to update 2 files: `slaves` and `docker-compose.yml`. And then rebuild the image and start containers by:

```
    docker-compose down
    ./build
    docker-compose up
```

*   For example, if I want to add 2 more datanodes, just add `datanode4` and `datanode5` in `slaves`, each line with one node. and in `docker-compose.yml`, follow the same way we do `datanode3`, give them new `ipv4_address` and different `ports`, then update each container's `extra_hosts` with the new `hostname:ip` pairs.

*   The reason we have to rebuild the image is that we update the `slaves` file, and it needs to be uploaded to the `namenode` container to read. Maybe I can just mount this file so I don't need to rebuild? TODO next.

## Extra:
*   To access hadoop's web UI, first find docker machine's ip: `docker-machine ip`, then go to `http://192.168.99.100:8088/` (192.168.99.100 is the docker machine's ip address)

