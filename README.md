# docker-minecraft

a simple tool for setting up a paper minecraft server in a docker container. it's mostly for my specific use case at the moment but my plan is to try and genericize it as much as possible in the future.

### instructions

* modify server.properties however you want
* in root dir of docker-minecraft (example paths used for run command. you can use your own path or omit.):

```shell
    docker build -t docker-minecraft .
    docker system prune
    docker run -d -p 25565:25565 -v "C:/docker-minecraft-data:/opt/minecraft" --name mc docker-minecraft
    docker logs --follow mc
```

* at this point you can start up the minecraft client and connect to a local network and see the server.

* to stop:

    docker stop mc

* to start up a stopped instance:

    docker start mc
