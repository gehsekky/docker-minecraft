FROM docker.io/eclipse-temurin:25-jre

ENV MINECRAFT_VERSION=26.3 \
    JAVA_MEMORY=2G \
    OP_LEVEL=4 \
    USE_AIKARS_FLAGS=true

# install necessary libs
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    jq && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -d /home/mcuser -s /bin/bash mcuser

# copy over local files to container
COPY docker-minecraft server.properties /

RUN chmod 755 /docker-minecraft && \
    chmod 644 /server.properties && \
    chown mcuser:mcuser /docker-minecraft /server.properties && \
    mkdir -p /opt/minecraft && \
    chown -R mcuser:mcuser /opt/minecraft

EXPOSE 25565

USER mcuser

# healthy once the server accepts connections; the long start period covers the first
# run's download and world generation.
HEALTHCHECK --interval=30s --timeout=5s --start-period=5m --start-interval=5s --retries=3 \
    CMD bash -c '</dev/tcp/localhost/25565'

ENTRYPOINT [ "/docker-minecraft" ]
