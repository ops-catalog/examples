kubectl exec -it cassandra-0 -- cqlsh -ucassandra -pcassandra -e 'select keyspace_name from system_schema.keyspaces;'|grep -v system

