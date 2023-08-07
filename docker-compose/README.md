# Docker compose

Docker compose folder contains everything required to setup an entire ecosystem from scratch

The folder contains:

- bare.yaml
- monitor.yaml
- networking.yaml
- elk.yaml
- sqldb.yaml
- neo4jdb.yaml

## Bare

bare.yaml file allows to run:

- RabbitMQ
- Redis
- MongoDB

``` Powershell
docker-compose -f ./bare.yaml up -d
```

### RabbitMQ

Check Rabbit console at:

[Rabbit Local](http://localhost:15672) guest/guest

### Redis cache

TBV

### MongoDB

TBV

## Monitor

monitor.yaml file allows to run:

- Grafana
- Promotheus
- Jaeger
- InfluxDb
- Seq

``` Powershell
docker-compose -f ./monitor.yaml up -d
```

## Networking

monitor.yaml file allows to run:

- Consul
- Fabio
- Vault

``` Powershell
docker-compose -f ./networking.yaml up -d
```

## Elastic Stack

ELK allows to run:

- Elastic Search
- Kibana
- LogStash
- head plugin

 with Elastic Search healthcheck

``` Powershell
docker-compose -f ./elk.yaml up -d
```

## Sql Server

sqldb.yaml file allows to run:

- Microsoft SQL Server Database

``` Powershell
docker-compose -f ./sqldb.yaml up -d
```

## neo4j Database

neo4jdb.yaml file allows to run:

- Neo4j Community Database

``` Powershell
docker-compose -f ./neo4jdb.yaml up -d
```
