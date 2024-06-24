#!/usr/bin/env bash

cmd=$1
recipe=$2


usage(){
  local code=$1
  echo 'a recipe can be run like this:

  ./run.sh recipe <name>
  ./run.sh down

Recipe command runs one of the available recipes.

name:
-----
simple      - a catalog server with sample catalog items loaded from ./datasets/catalog/my-account
minimal     - a basic setup with catalog, ui, postgres and some seed data
ssl         - a basic setup with catalog, ui and postgres with TLS
edge        - aggregator catalog discovers data from edge catalog
discovery   - performs discovery against few targets like postgres, cassandra, airflow, k8s, kafka and presents in UI
fulfillment - provisions resources in catalog which are not yet in target servers
all         - runs discovery, fulfillment and catalog

Down command shuts down the running containers.
'
exit $code;
}

cn=$#
if [[ $cn -eq 0 ]];
then
  usage 0
fi;

runRecipe() {
  local name=$1
  if [[ $name == "" ]];
  then
    echo "recipe name required"
    usage 1;
  fi;
  if [[ "$name" == "all" ]];
  then
    name="fulfillment"
  fi;
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
  recipe)
    runRecipe $recipe
    ;;
  *)
    usage 1;
    ;;
esac;
