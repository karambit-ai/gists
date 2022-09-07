# syntax=docker.io/docker/dockerfile-upstream:1.4.3

ARG VARIANT="jammy"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

COPY .devcontainer/scripts/*.sh /tmp/

RUN /tmp/apt.sh <<EOF
shellcheck
EOF
RUN /tmp/hooks.sh

USER vscode

COPY --chown=vscode .tool-versions /home/vscode/.tool-versions

RUN /tmp/asdf.sh <<EOF
github-cli
EOF
