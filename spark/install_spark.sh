sudo apt-get -y install openjdk-8-jdk-headless
wget -q https://dlcdn.apache.org/spark/spark-3.2.1/spark-3.2.1-bin-hadoop3.2.tgz
tar -xzvf spark-3.2.1-bin-hadoop3.2.tgz
pip install -q findspark
pip install pyspark
