kubectl get sts cassandra >/dev/null 2>&1
if [[ $? -eq 0 ]];
then
  echo dropping existing keyspace "FAQ"
  kubectl exec -it cassandra-0 -- cqlsh -e "drop keyspace if exists faq;"
  kubectl exec -it cassandra-0 -- cqlsh -e "drop keyspace if exists audit;"
  kubectl exec -it cassandra-0 -- cqlsh -e "drop keyspace if exists notificationstore;"
fi;

kubectl get sts postgres >/dev/null 2>&1
if [[ $? -eq 0 ]];
then
  echo dropping existing schema in postgres
  kubectl exec -it postgres-0 -- psql -Upostgres -dservicing -c 'DROP SCHEMA IF EXISTS refdata cascade;'
  kubectl exec -it postgres-0 -- psql -Upostgres -dservicing -c 'DROP SCHEMA IF EXISTS account cascade;'

  kubectl exec -it postgres-0 -- psql -Upostgres -dpreferences -c 'DROP SCHEMA IF EXISTS onboarding cascade;'
  kubectl exec -it postgres-0 -- psql -Upostgres -dpreferences -c 'DROP SCHEMA IF EXISTS merchants cascade;'
  kubectl exec -it postgres-0 -- psql -Upostgres -dpreferences -c 'DROP SCHEMA IF EXISTS userdata cascade;'

fi;

kubectl get sts kafka >/dev/null 2>&1
if [[ $? -eq 0 ]];
then 
  echo dropping existing topics in kafka
  kubectl exec -it kafka-0 -- kafka-topics.sh --delete --topic jobs.dlq --bootstrap-server kafka-0:9092

  kubectl exec -it kafka-0 -- kafka-topics.sh --delete --topic audit.events --bootstrap-server kafka-0:9092
  kubectl exec -it kafka-0 -- kafka-topics.sh --delete --topic devops.deployment-events --bootstrap-server kafka-0:9092
  kubectl exec -it kafka-0 -- kafka-topics.sh --delete --topic onboarding.events --bootstrap-server kafka-0:9092
fi;

