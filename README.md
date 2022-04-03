# docker-minecraft

### instructions

* in root dir of docker-minecraft:

    docker build -t docker-minecraft .
    docker system prune
    docker run -d -p 25565:25565 -v "C:/Users/andy/Downloads/docker-minecraft-data:/opt/minecraft" --name mc docker-minecraft
    docker logs --follow mc

* to stop:

    docker stop mc

* to start up a stopped instance:

    docker start mc
