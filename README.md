# docker-minecraft

a simple tool for setting up a paper minecraft server in a docker container. it's mostly for my specific use case at the moment but my plan is to try and genericize it as much as possible in the future.

### configuration

* edit `server.properties` however you want (copied on first run, i.e. when the data volume doesn't have one yet; after that, edit the copy in the data volume)
* the container is controlled by these environment variables:

| variable | default | description |
| --- | --- | --- |
| `EULA` | `false` | must be set to `true` to accept the [Minecraft EULA](https://aka.ms/MinecraftEULA); the server won't start otherwise |
| `MINECRAFT_VERSION` | `26.3` | Minecraft version to fetch the latest Paper build for. changing it downloads that version on the next start |
| `ALLOW_DOWNGRADE` | `false` | allow changing to an older `MINECRAFT_VERSION`, which can damage the world. back up first |
| `JAVA_MEMORY` | `2G` | heap size, used for both `-Xms` and `-Xmx` |
| `OPS` | _(empty)_ | comma-separated Minecraft usernames and/or UUIDs to grant admin (op) |
| `OP_LEVEL` | `4` | op permission level for everyone in `OPS` (4 = full admin) |
| `USE_AIKARS_FLAGS` | `true` | apply [Aikar's JVM flags](https://docs.papermc.io/paper/aikars-flags) for performance |
| `USER_AGENT` | `docker-minecraft/1.0 (https://github.com/gehsekky/docker-minecraft)` | User-Agent sent to the PaperMC [Fill API](https://fill.papermc.io); must be non-generic and include a contact |

### admin access

* set `OPS` to your Minecraft username (e.g. `OPS=Notch`) and start the server. usernames are resolved to UUIDs via Mojang's API; you can also pass UUIDs directly. multiple admins: `OPS=Notch,jeb_,<uuid>`.
* `ops.json` is updated on every start: adding or removing someone in `OPS` and restarting ops or deops them. admins added in-game with `/op` are kept, but someone still listed in `OPS` is re-opped after `/deop` on the next start.
* if a username can't be resolved (e.g. Mojang's API is down), an admin already in `ops.json` keeps their entry.
* this assumes `online-mode=true` (the default in `server.properties`), so the Mojang-resolved UUID matches the one you log in with. if you switch to an offline/LAN server (`online-mode=false`), pass the offline UUID directly instead of a username.
* with op you have full in-game admin powers (`/gamemode`, `/op`, `/give`, etc.).

### usage with docker compose (recommended)

copy `.env.example` to `.env`, set `EULA=true`, and add your username to `OPS`. then:

```shell
docker compose up -d --build
docker compose logs --follow
```

* the world and all other server data live in `./docker-minecraft-data`. set `MINECRAFT_DATA` in `.env` to keep them somewhere else.

* stop: `docker compose stop`
* start a stopped instance: `docker compose start`
* tear down (keeps the `./docker-minecraft-data` volume): `docker compose down`

### usage with plain docker

```shell
docker build -t docker-minecraft .
docker run -d -p 25565:25565 -e EULA=true --stop-timeout 120 -v "${PWD}/docker-minecraft-data:/opt/minecraft" --name mc docker-minecraft
docker logs --follow mc
```

* stop: `docker stop mc`
* start a stopped instance: `docker start mc`

at this point you can start up the minecraft client, connect to a local network, and see the server.
