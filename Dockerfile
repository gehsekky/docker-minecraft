FROM openjdk:19-jdk-alpine3.15

# install necessary libs
RUN apk add -U \
    bash \
    dos2unix \
    git \
    curl \
    wget \
    jq

# copy over local files to container and sanitize
COPY docker-minecraft server.properties /

RUN dos2unix \
        /docker-minecraft \
        /server.properties

EXPOSE 25565

ENTRYPOINT [ "/docker-minecraft" ]

ENV EULA=true MINECRAFT_VERSION=1.18.2
