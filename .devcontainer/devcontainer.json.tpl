{
  "name": "Ubuntu",
  "build": {
    "context": "..",
    "dockerfile": "Dockerfile",
    "args": {
      "VARIANT": "ubuntu-22.04"
    }
  },

  # NB: Enables SSH into GitHub Codespaces.
  # "features": {
  #   "ghcr.io/devcontainers/features/sshd:1": {
  #     "version": "latest"
  #   }
  # },

  # NB: Configure default resource requirements for the Codespace.
  # "hostRequirements": {
  #   "cpus": 4,
  #   "memory": "8gb"
  # },

  "remoteUser": "vscode",
  "customizations": {
    # NB: Add other private repositories that should also be cloned.
    # "codespaces": {
    #   "repositories": {
    #     "karambit-ai/gists": {
    #       "permissions": {
    #         "contents": "read",
    #         "packages": "read"
    #       }
    #     }
    #   }
    # },
    "vscode": {
      "extensions": [
        "bierner.markdown-mermaid",
        "foxundermoon.shell-format",
        "timonwong.shellcheck"
      ],
      "settings": {
        "editor.formatOnSave": true,
        "[shellscript]": {
          "editor.defaultFormatter": "foxundermoon.shell-format"
        }
      }
    }
  }
}
