FROM ubuntu:22.04 AS builder

WORKDIR /tmp

ARG GMINER_VERSION="2.97"
ARG GMINER_FILENAME="gminer_2_97_linux64.tar.xz"

RUN mkdir gminer &&\
    apt update && apt install tar wget xz-utils -y

RUN wget https://github.com/develsoftware/GMinerRelease/releases/download/${GMINER_VERSION}/${GMINER_FILENAME} && \
    tar xf ${GMINER_FILENAME} -C gminer


FROM nvidia/cuda:11.7.0-base-ubuntu22.04

LABEL maintainer="Dockminer"

LABEL org.opencontainers.image.source https://github.com/dockminer/gminer

# Fix Driver bug
RUN ln -s /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so

COPY --from=builder /tmp/gminer/miner /usr/local/bin/miner

EXPOSE 8080

ENTRYPOINT [ "miner" ]
