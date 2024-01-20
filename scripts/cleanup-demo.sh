cwd=$(dirname "$0")
account_dir=$cwd/../datasets/my-account
if [[ -f ${account_dir}/audit-topic.yaml ]]; then 
  rm ${account_dir}/audit-topic.yaml 
fi;

if [[ -f ${account_dir}/audit-schema.yaml ]];then
  rm ${account_dir}/audit-schema.yaml
fi;

if [[ -f ${account_dir}/merchants-schema.yaml ]];then 
  rm ${account_dir}/merchants-schema.yaml
fi;

if [[ -f ${account_dir}/bucket-attachments.yaml ]];then 
  rm ${account_dir}/bucket-attachments.yaml
fi;

kubectl get sts cassandra >/dev/null 2>&1
if [[ $? -eq 0 ]];
then 
  echo dropping existing keyspace "FAQ"
  kubectl exec -it cassandra-0 -- cqlsh -e "drop keyspace if exists faq;"
fi;

kubectl get sts postgres >/dev/null 2>&1
if [[ $? -eq 0 ]];
then 
  echo dropping existing schema in postgres
  kubectl exec -it postgres-0 -- psql -Upostgres -dservicing -c 'DROP SCHEMA IF EXISTS refdata cascade;' 
fi;

