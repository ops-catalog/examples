#!/usr/bin/env bash
if [[ -z $CASSANDRA_HOST ]];
then
  echo "Cassandra Host required"
  exit 1;
fi;

c=0
total=0
for f in $(ls /tmp/data/*.cql);
do
  total=$((total + 1))
  cqlsh -u${CASS_USER} -p${CASS_PASSWORD} -f ${f} ${CASSANDRA_HOST} 9042
  if [[ $? -eq 0 ]];
  then
    c=$((c + 1))
  fi;
done;

echo "executed ${c} out of ${total} files"




