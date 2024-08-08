{ pkgs, lib, config, inputs, ... }:

{
  packages = with pkgs; ([
    curl
    git
  ] ++ lib.optionals (!config.container.isBuilding) [
    cloudflared
    direnv
    emacs
    entr
    fzf
    github-cli
    gnupg
    jq
    less
    magic-wormhole
    ripgrep
    rlwrap
    tmux
    vault
    vim
    wget
  ]);

  pre-commit.hooks = {
    actionlint.enable = true;
    check-json.enable = true;
    check-merge-conflicts.enable = true;
    check-yaml.enable = true;
    mixed-line-endings.enable = true;
    shellcheck.enable = true;
    trim-trailing-whitespace.enable = true;
  };
}
