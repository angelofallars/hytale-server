FROM alpine:3.23.2 AS builder

RUN mkdir -p /downloads
WORKDIR /downloads

RUN wget https://downloader.hytale.com/hytale-downloader.zip \
    unzip hytale-downloader.zip

RUN ./hytale-downloader-linux-amd64 -version

# Trigger authentication flow.
# Currently this requires going through a browser auth flow, no way around it.
RUN ./hytale-downloader-linux-amd64 -print-version

RUN ./hytale-downloader-linux-amd64 -print-version > /hytale-version

# Download game
RUN mkdir -p /server/bin \
    ./hytale-downloader-linux-amd64 -patchline release \
    unzip "$(cat /hytale-version)" -d /server/bin \
    mv /server/bin/Server/* /server/bin \
    rmdir /server/bin/Server

FROM eclipse-temurin:25 AS runner

COPY --from=builder /server/bin /server/bin

RUN apt-get update && \
    apt-get install -y tmux

RUN mkdir -p /server/data /server/data/plugins

WORKDIR /server/data

COPY scripts/tmux_entrypoint.sh /server/bin/tmux_entrypoint.sh

ENTRYPOINT [ "/server/bin/tmux_entrypoint.sh" ]

CMD [ "java", "-jar", "/server/bin/HytaleServer.jar", "--assets", "/server/bin/Assets.zip", \
      "--early-plugins", "/server/data/plugins" ]
