# syntax=docker/dockerfile:1.3
FROM debian:bookworm AS build
ENV DEBIAN_FRONTEND=noninteractive
ARG USE_CCACHE
RUN apt-get update && apt-get -y full-upgrade && \
    apt-get install -y build-essential wget git ccache cmake ninja-build libssl-dev jq python3 glslang-tools

COPY . /root/build-files

RUN --mount=type=cache,id=ccache,target=/root/.ccache \
    /root/build-files/.ci/fetch.sh /root/citra-canary && \
    cd /root/citra-canary && /root/build-files/.ci/build.sh

FROM gcr.io/distroless/cc-debian11 AS final
LABEL maintainer="citraemu"
# Create app directory
WORKDIR /usr/src/app
COPY --from=build /root/citra-canary/build/bin/Release/citra-room /usr/src/app

ENTRYPOINT [ "/usr/src/app/citra-room" ]
