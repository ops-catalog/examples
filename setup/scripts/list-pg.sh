
echo "Schemas Under preferences"
kubectl exec -it postgres-0 -- psql -Upostgres -d preferences -c "select catalog_name,schema_name from information_schema.schemata where schema_name not in ('information_schema', 'pg_toast', 'public', 'pg_catalog');"

echo "Schemas under servicing"
kubectl exec -it postgres-0 -- psql -Upostgres -d servicing -c "select catalog_name,schema_name from information_schema.schemata where schema_name not in ('information_schema', 'pg_toast', 'public', 'pg_catalog');"

