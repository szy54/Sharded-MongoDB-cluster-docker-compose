# Sharded-MongoDB-cluster-docker-compose
A simple sharded MongoDB cluster using `docker-compose`. Tested for MongoDB v4.2.

Designed to be a simple and quick to get a local dev/test environment up. **Not for use in production**.
### Mongo components
* 1 Config server (3-node replica set `rs-cfg`): `config-01`, `config-02`, `config-03`
* 2 Shards (3-node PSS replica sets `rs-a`, `rs-b`):
  * `rs-a`: `shard-a-01`, `shard-a-02`, `shard-a-03`
  * `rs-b`: `shard-b-01`, `shard-b-02`, `shard-b-03`
* 1 router `router`
* Data persistence using volumes in *~/mongo-cluster*

### First usage
1. **Start the containers in a detached mode**:
```
docker-compose up -d
```
2. **Configure the replica sets and shards**:
```
sh init.sh
```
The `sleep 20` in a script is for the replica sets to let them elect the primary.

3. **You can verify replica sets and shards using:**

`rs-a`:
```
docker-compose exec shard-a-01 sh -c "mongo --port 27018"
>rs.status()
```
`rs-b`:
```
docker-compose exec shard-b-01 sh -c "mongo --port 27018"
>rs.status()
```
`rs-cfg`:
```
docker-compose exec config-01 sh -c "mongo --port 27019"
>rs.status()
```
shards:
```
docker-compose exec router sh -c "mongo --port 27017"
>sh.status()
```

### Regular usage
Since the containers preserve data using volumes, you can simply
```
docker-compose up -d
```
and
```
docker-compose down
```

### How to connect
You must finish the configuration for **your database** following [this doc](https://docs.mongodb.com/v4.2/tutorial/deploy-shard-cluster/#enable-sharding-for-a-database) i.e. **Enable Sharding for a Database** and **Shard a Collection**

For Read/Write operations you should use only the router([official docs](https://docs.mongodb.com/manual/sharding/#connecting-to-a-sharded-cluster)). 
You have the router's mongo port translated to *localhost:30031*, so to connect to a mongo shell:
```
mongo --port 30031
```




### Resetting cluster
Make sure the containers are stopped and:
```
docker-compose rm
```
Then execute the **First usage** instructions again