FROM eclipse-temurin:25-jre

ENV MINECRAFT_VERSION=26.2 \
    JAVA_MEMORY=2G \
    OP_LEVEL=4 \
    USE_AIKARS_FLAGS=true

# install necessary libs
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    dos2unix \
    jq && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -d /home/mcuser -s /bin/bash mcuser

# copy over local files to container and sanitize
COPY docker-minecraft server.properties /

RUN chmod 755 /docker-minecraft && \
    chmod 644 /server.properties && \
    chown mcuser:mcuser /docker-minecraft /server.properties && \
    dos2unix /docker-minecraft /server.properties && \
    mkdir -p /opt/minecraft && \
    chown -R mcuser:mcuser /opt/minecraft

EXPOSE 25565

USER mcuser

ENTRYPOINT [ "/docker-minecraft" ]
