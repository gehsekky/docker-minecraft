FROM eclipse-temurin:24-jre

# install necessary libs
RUN apt-get update && \
    apt-get install -y \
    bash \
    dos2unix \
    git \
    curl \
    jq

RUN useradd -m -d /home/mcuser -s /bin/bash mcuser

# copy over local files to container and sanitize
COPY docker-minecraft server.properties /

RUN chmod 755 /docker-minecraft && \
    chmod 644 /server.properties && \
    chown mcuser:mcuser /docker-minecraft /server.properties

RUN mkdir -p /opt/minecraft && \
    chown -R mcuser:mcuser /opt/minecraft

RUN dos2unix \
    /docker-minecraft \
    /server.properties

EXPOSE 25565

USER mcuser

ENTRYPOINT [ "/docker-minecraft" ]

ENV EULA=true MINECRAFT_VERSION=1.21.4
