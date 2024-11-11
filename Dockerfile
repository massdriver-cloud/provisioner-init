# This Dockerfile is intended to be built from the top of the repo (not this directory)
ARG XO_VERSION=latest
ARG RUN_IMG=debian:12.7-slim
ARG USER=massdriver
ARG UID=10001

FROM 005022811284.dkr.ecr.us-west-2.amazonaws.com/massdriver-cloud/xo:${XO_VERSION} AS xo

FROM ${RUN_IMG}
ARG USER
ARG UID

RUN apt update && apt install -y ca-certificates unzip && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p -m 777 /massdriver

RUN adduser \
    --disabled-password \
    --gecos "" \
    --uid $UID \
    $USER
RUN chown -R $USER:$USER /massdriver
USER $USER

COPY --from=xo /usr/bin/xo /usr/local/bin/xo
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

WORKDIR /massdriver

ENTRYPOINT ["entrypoint.sh"]