#!/usr/bin/env bash

cmd=$1
scenario=$2


usage(){
  local code=$1
  echo 'a scenario can be run like this:

  ./run.sh scenario <name>
  ./run.sh down

Scenario command runs one of the available scenarios.
name:
--------------
simple    - a catalog server with sample catalog items loaded from ./datasets/catalog/my-account
minimal   - a basic setup with catalog, ui, postgres and some seed data
ssl       - a basic setup with catalog, ui and postgres with TLS
edge      - aggregator catalog discovers data from edge catalog

Down command shuts down the running containers.
'
exit $code;
}

cn=$#
if [[ $cn -eq 0 ]];
then
  usage 0
fi;

runScenario() {
  local name=$1
  if [[ ! -f recipes/$name/docker-compose.yaml ]];
  then
    echo $name is not available;
    exit 1;
  fi;

  case $name in
    ssl)
    chmod 600 setup/containers/postgres/certs/*.key
    ;;
    *)
    ;;
  esac;
  cp recipes/$name/docker-compose.yaml docker-compose.yaml 
  docker compose up -d
}

case $cmd in 
  down)
    docker compose down
    ;;
  scenario)
    runScenario $scenario
    ;;
  *)
    usage 1;
    ;;
esac;
