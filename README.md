docker-compose exec crdb /bin/bash


docker-compose exec crdb /cockroach/cockroach sql --insecure --execute="CREATE DATABASE test;"