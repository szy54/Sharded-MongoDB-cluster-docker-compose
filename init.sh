#!/bin/bash

docker-compose exec config-01 sh -c "mongo --port 27019 < /scripts/init-config"
docker-compose exec shard-a-01 sh -c "mongo --port 27018 < /scripts/init-shard-a"
docker-compose exec shard-b-01 sh -c "mongo --port 27018 < /scripts/init-shard-b"
sleep 20
docker-compose exec router sh -c "mongo --port 27017 < /scripts/init-router"