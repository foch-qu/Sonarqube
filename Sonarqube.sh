#!/bin/bash
docker run --name pgdb -e POSTGRES_USER=cidana \
-e POSTGRES_PASSWORD=cidana \
-p 5432:5432 \
-v $PWD/sonarqube/data9/postgresql/data:/var/lib/postgresql/data \
-d --privileged postgres:12

docker run --name sq --link pgdb -e SONARQUBE_JDBC_USERNAME=cidana \
-e SONARQUBE_JDBC_PASSWORD=cidana \
-e SONARQUBE_JDBC_URL=jdbc:postgresql://pgdb:5432/cidana \
-p 9000:9000 \
-v $PWD/sonarqube/data9/sonarqube/data:/opt/sonarqube/data \
-v $PWD/sonarqube/data9/sonarqube/extensions:/opt/sonarqube/extensions \
-v $PWD/sonarqube/data9/sonarqube/logs:/opt/sonarqube/logs \
-d --privileged sonarqube:8.6.0-community




#-----------------------------------------------#
sudo sysctl -w vm.max_map_count=262144
# Change vm.max_map_count default value
sudo docker restart pgdb sq
#-----------------------------------------------#
