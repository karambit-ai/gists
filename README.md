# gists

This repository contains a collection of gists used across repositories in the
karambit-ai organization.

## devcontainer/

Repositories for the karambit-ai organization are standardized around providing
a common development environment for contributors.

Contributors are not required to use the development environment, but they are
used in CI and are the recommended way to develop for the organization.

The goals are to:

- provide a consistent development environment for contributors
- trivialize onboarding
- explore codebases without being familiar with the backing technologies

See:

- https://code.visualstudio.com/docs/remote/containers
- https://www.infoq.com/articles/devcontainers/
- https://github.com/features/codespaces

This `gists` repository contains a model setup for configuring a repository for
development in devcontainers.

The scripts in `devcontainer/` are meant to be copied into a repository and
overwritten as needed. Any repository-specific configuration should go into
`.devcontainer/devcontainer.json` and `.devcontainer/Dockerfile`.

When setting up or updating a new repository, run:

```bash
curl https://raw.githubusercontent.com/karambit-ai/gists/main/devcontainer/bootstrap.sh | bash
```

We additionally recommend that all karambit-ai repositories include the
following asdf plugins:

- cloudflared
- github-cli
- vault
