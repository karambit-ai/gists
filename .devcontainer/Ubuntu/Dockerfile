# syntax=docker.io/docker/dockerfile-upstream:1.4.3

ARG VARIANT="noble"
FROM mcr.microsoft.com/vscode/devcontainers/base:${VARIANT}

ENV ASDF_DATA_DIR="/opt/asdf"

# Install packages using the apt package manager.
# A list of common packages will be installed along with any packages you list
# here.
RUN curl -fsSL https://raw.githubusercontent.com/karambit-ai/gists/main/devcontainer/apt.sh > /tmp/apt.sh \
 && bash /tmp/apt.sh <<EOF
shellcheck
EOF

# Install common shell hooks (e.g. asdf, completion).
RUN curl -fsSL https://raw.githubusercontent.com/karambit-ai/gists/main/devcontainer/hooks.sh | bash -

COPY .tool-versions /root/.tool-versions

# Install packages using the asdf package manager.
RUN curl -fsSL https://raw.githubusercontent.com/karambit-ai/gists/main/devcontainer/asdf.sh > /tmp/asdf.sh \
 && bash /tmp/asdf.sh <<EOF
cloudflared
github-cli
vault
EOF

USER vscode
