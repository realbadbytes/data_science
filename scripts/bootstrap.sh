#!/bin/bash

export AIRFLOW_HOME=~/airflow
export ES_HOME=/home/user/elasticsearch-7.15.0
export SCRIPT_HOME=/home/user/data_science/scripts

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

# Elasticsearch
$ES_HOME/bin/elasticsearch &> es.log &
# wait for ES to start
sleep 5
# populate with data
python3 $SCRIPT_HOME/bulk_ingest.py
# test query
python3 $SCRIPT_HOME/elasticsearch_test.py
