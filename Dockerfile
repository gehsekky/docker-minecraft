FROM openjdk:8u171-jre-alpine

# install necessary libs
RUN apk add -U \
    bash \
    dos2unix \
    git \
    wget

# copy over local files to container and sanitize
COPY docker-minecraft server.properties /

RUN dos2unix \
        /docker-minecraft \
        /server.properties

EXPOSE 25565

ENTRYPOINT [ "/docker-minecraft" ]

ENV EULA=true MINECRAFT_VERSION=1.13.1 DEFAULT_OP=stopfriction
