cd $HADOOP_PREFIX

# create wordcount files
mkdir wordcount
echo "Hello World" >wordcount/file1.txt
echo "Hello Docker" >wordcount/file2.txt
echo "Hello Hadoop in Docker" >wordcount/file3.txt

# create input directory on HDFS
hadoop fs -mkdir -p input

# put wordcount files to HDFS
hdfs dfs -put ./wordcount/* input

# run wordcount
hadoop jar ./share/hadoop/mapreduce/sources/hadoop-mapreduce-examples-2.7.4-sources.jar \
org.apache.hadoop.examples.WordCount input output

# print the input files
echo -e "\ninput file1.txt:"
hdfs dfs -cat input/file1.txt

echo -e "\ninput file2.txt:"
hdfs dfs -cat input/file2.txt

# print the output of wordcount
echo -e "\nwordcount output:"
hdfs dfs -cat output/part-r-00000
