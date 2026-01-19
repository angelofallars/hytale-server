FROM alpine:3.23.2 AS builder

RUN mkdir -p /downloads

WORKDIR /downloads

RUN wget https://downloader.hytale.com/hytale-downloader.zip
RUN unzip hytale-downloader.zip

RUN ./hytale-downloader-linux-amd64 -version

# Trigger authentication flow
RUN ./hytale-downloader-linux-amd64 -print-version

RUN ./hytale-downloader-linux-amd64 -print-version > /hytale-version

# Download game
RUN mkdir -p /server/bin
RUN ./hytale-downloader-linux-amd64 -patchline release
RUN unzip "$(cat /hytale-version)" -d /server/bin
RUN mv /server/bin/Server/* /server/bin
RUN rmdir /server/bin/Server

FROM eclipse-temurin:25 AS runner

COPY --from=builder /server/bin /server/bin

RUN apt-get update && \
    apt install -y tmux

RUN mkdir -p /server/data
RUN mkdir -p /server/data/plugins

WORKDIR /server/data

ADD tmux_entrypoint.sh /server/bin/tmux_entrypoint.sh

ENTRYPOINT [ "/server/bin/tmux_entrypoint.sh" ]

CMD [ "java", "-jar", "/server/bin/HytaleServer.jar", "--assets", "/server/bin/Assets.zip", \
      "--early-plugins", "/server/data/plugins" ]
