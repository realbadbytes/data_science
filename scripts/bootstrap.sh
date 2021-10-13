#!/bin/bash

export AIRFLOW_HOME=~/airflow
export ES_HOME=/home/user/elasticsearch-7.15.0
export SCRIPT_HOME=/home/user/data_science/scripts

echo "Startin up airflow"

# Airflow
# some of these initialization steps can be removed once we have a real instance running
AIRFLOW_VERSION=2.1.4
PYTHON_VERSION="$(python3 --version | cut -d " " -f 2 | cut -d "." -f 1-2)"
CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"
pip install "apache-airflow==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}" &> /dev/null
airflow db init &> airflow.log &
airflow users create --username admin --firstname b --lastname b --role Admin --email badbytesio@gmail.com --password admin &> airflow.log &
airflow webserver --port 8080 &> airflow.log &
airflow scheduler &> airflow.log &

echo "Airflow running"
fuser 8080/tcp

echo "Startin up ES"

# Elasticsearch
$ES_HOME/bin/elasticsearch &> es.log &
# wait for ES to start
while ! timeout 1 bash -c "echo > /dev/tcp/localhost/9200"; do sleep 5; done
# populate with data
#python3 $SCRIPT_HOME/bulk_ingest.py
echo "test query"
 python3 $SCRIPT_HOME/elasticsearch_test.py
