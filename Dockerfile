# This Dockerfile is intended to be built from the top of the repo (not this directory)
ARG RUN_IMG=debian:12.7-slim
ARG USER=massdriver
ARG UID=10001

FROM ${RUN_IMG} AS build

# install opentofu, opa, yq, massdriver cli, kubectl
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y curl jq && \
    rm -rf /var/lib/apt/lists/* && \
    curl -s https://api.github.com/repos/massdriver-cloud/xo/releases/latest | jq -r '.assets[] | select(.name | contains("linux-amd64")) | .browser_download_url' | xargs curl -sSL -o xo.tar.gz && tar -xvf xo.tar.gz -C /tmp && mv /tmp/xo /usr/local/bin/ && rm *.tar.gz

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

COPY --from=build /usr/local/bin/* /usr/local/bin/
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

WORKDIR /massdriver

ENTRYPOINT ["entrypoint.sh"]