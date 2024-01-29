#!/usr/bin/env bash

if [[ -z $PG_HOST ]];
then
  echo "Postgres Host required"
  exit 1;
fi;

for f in $(ls /tmp/data/*.sql);
do
  psql -U${PG_USER} -h${PG_HOST} -f ${f}
done;

