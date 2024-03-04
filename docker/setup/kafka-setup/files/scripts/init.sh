#!/usr/bin/env bash

if [[ -z $KAFKA_HOST ]];
then
  echo "Kafka Host required"
  exit 1;
fi;

if [[ -z $TOPICS ]]; then
  echo "no TOPICS provided"
  exit 0;
fi;

echo topic list before change
kafka-topics.sh  --list --bootstrap-server ${KAFKA_HOST}:9092

for t in $(echo $TOPICS|sed s/,/\\n/g);
do
  kafka-topics.sh --create --if-not-exists --topic "${t}" --bootstrap-server ${KAFKA_HOST}:9092 --replication-factor 1
done;

echo topic list after change
kafka-topics.sh  --list --bootstrap-server ${KAFKA_HOST}:9092





