# Docker compose

Docker compose folder contains everything required to setup an entire echosystem from scratch

The folder contains:
 - bare.yml
 - monitor.yml
 - elk.yml
 - sqldb.yml
 - neo4jdb.yml


 ## Bare

 bare.yml file allows to run:
 - RabbitMQ
 - Redis
 - MongoDB

``` Powershell
docker-compose -f ./docker/bare.yml up -d
```

### RabbitMQ

http://localhost:15672 guest/guest

### Redis cache

TBV

### MongoDB

TBV


---

 ## Monitor

 monitor.yml file allows to run:
 - Consul
 - Fabio
 - Grafana
 - Promotheus
 - Vault
 - Jaeger
 - InfluxDb
 - Seq

``` Powershell
docker-compose -f ./docker/monitor.yml up -d
```

 ## Sql Server

 sqldb.yml file allows to run:
 - Microsoft SQL Server Database

``` Powershell
docker-compose -f ./docker/sqldb.yml up -d
```

 ## neo4j Database

 neo4jdb.yml file allows to run:
 - Neo4j Community Database

``` Powershell
docker-compose -f ./docker/neo4jdb.yml up -d
```
