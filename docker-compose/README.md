# Docker compose

Docker compose folder contains everything required to setup an entire ecosystem from scratch

The folder contains:
 - bare.yml
 - monitor.yml
 - networking.yml
 - elk.yml
 - sqldb.yml
 - neo4jdb.yml

 ## Bare

 bare.yml file allows to run:
 - RabbitMQ
 - Redis
 - MongoDB

``` Powershell
docker-compose -f ./bare.yml up -d
```

### RabbitMQ

Check Rabbit console at:

[Rabbit Local](http://localhost:15672) guest/guest

### Redis cache

TBV

### MongoDB

TBV


---

 ## Monitor

 monitor.yml file allows to run:
 - Grafana
 - Promotheus
 - Jaeger
 - InfluxDb
 - Seq

``` Powershell
docker-compose -f ./monitor.yml up -d
```


 ## Networking

 monitor.yml file allows to run:
 - Consul
 - Fabio
 - Vault

``` Powershell
docker-compose -f ./networking.yml up -d
```

 ## Elastic Stack

 ELK allows to run:
 - Elastic Search
 - Kibana
 - LogStash
 - head plugin

 with Elastic Search healthcheck

``` Powershell
docker-compose -f ./elk.yml up -d
```


 ## Sql Server

 sqldb.yml file allows to run:
 - Microsoft SQL Server Database

``` Powershell
docker-compose -f ./sqldb.yml up -d
```

 ## neo4j Database

 neo4jdb.yml file allows to run:
 - Neo4j Community Database

``` Powershell
docker-compose -f ./neo4jdb.yml up -d
```
