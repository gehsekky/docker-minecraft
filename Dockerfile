FROM eclipse-temurin:22-jre

# install necessary libs
RUN apt-get update && \
    apt-get install -y \
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

ENV EULA=true MINECRAFT_VERSION=1.20.6
