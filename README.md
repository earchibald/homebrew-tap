# earchibald/tap

A Homebrew tap.

```sh
brew tap earchibald/tap
```

| Formula | Description |
|---|---|
| [claude-completions](https://github.com/earchibald/claude-code-completions) | Bash and zsh tab completion for the Claude Code CLI |

## Install

```sh
brew install earchibald/tap/claude-completions
claude-completions install
```

## How releases are pinned

Each formula points at an uploaded release asset, not a mutable branch or an
auto-generated archive, and pins its `sha256`. Homebrew verifies that checksum
on every download, so a changed upstream file fails the install rather than
running.

Release tarballs are built reproducibly with `git archive` from a signed tag.
To check a release yourself:

```sh
git clone https://github.com/earchibald/claude-code-completions
cd claude-code-completions
git tag -v v1.0.0                 # verify the tag signature
git archive --format=tar.gz --prefix=claude-completions-1.0.0/ v1.0.0 |
  shasum -a 256                   # must match the sha256 in the formula
```

Verifying the tag signature needs the signing key in your
`gpg.ssh.allowedSignersFile`.
