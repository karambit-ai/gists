# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.236.0/containers/ubuntu/.devcontainer/base.Dockerfile

# [Choice] Ubuntu version (use ubuntu-22.04 or ubuntu-18.04 on local arm64/Apple Silicon): ubuntu-22.04, ubuntu-20.04, ubuntu-18.04
ARG VARIANT="jammy"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

# Install a specific version of Node.js.
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
 && apt-get -y install --no-install-recommends \
      curl \
      direnv \
      entr \
      g++ \
      gcc \
      gpg \
      jq \
      make \
      pre-commit \
      python3-pip \
      python3-venv \
      ripgrep \
      tmux \
      vim \
      wget

# Setup bashrc hooks for direnv and asdf.
RUN echo "\neval \"\$(direnv hook bash)\"" >> /etc/bash.bashrc \
 && echo "\n. ~/.asdf/asdf.sh" >> /etc/bash.bashrc             \
 && echo ". ~/.asdf/completions/asdf.bash" >> /etc/bash.bashrc

USER vscode

# Install asdf version manager.
RUN git clone https://github.com/asdf-vm/asdf ~/.asdf \
      --branch v0.10.2

# COPY --chown=vscode .tool-versions /home/vscode/.tool-versions
# COPY --chown=vscode .devcontainer/scripts/asdf.sh /tmp/asdf.sh
# COPY --chown=vscode .devcontainer/scripts/asdf-plugins.list /tmp/asdf-plugins.list

# Install asdf plugins.
# RUN /tmp/asdf.sh
