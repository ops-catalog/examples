### Setup 

Bring all up
```
docker compose up -d
```

#### Profiles

bring postgres, cassandra and data jobs
```shell
docker compose --profile db up -d
```

bring kafka and kafka-setup job
```shell
docker compose --profile kafka up -d
```



