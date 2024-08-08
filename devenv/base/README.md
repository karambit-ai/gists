# devenv/base

This is a base devenv configuration that should be imported into other
development devenvs.

It splits dependencies so that development-only dependencies are omitted during
container builds.

The setup should be roughly equivalent to the asdf-based `devcontainer/`
configuration.
