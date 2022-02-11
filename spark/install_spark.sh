sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install openjdk-8-jdk-headless
wget -q https://dlcdn.apache.org/spark/spark-3.2.1/spark-3.2.1-bin-hadoop3.2.tgz -P /project
pushd /project
tar -xzvf spark-3.2.1-bin-hadoop3.2.tgz
popd
pip install -q findspark
pip install pyspark
