# `os-release` query

A basic tool to print specific `/etc/os-release` details and other checks.

## Install

Run `bash scripts/install.sh 0.0.2` to install from web

Run `bash scripts/install.sh` to build and install. Requires Zig toolchain v0.13.0 .

## Design

The following is intended to be the full set of operations:

* `os-release` - print `<ID>:<VERSION_ID>`
* `os-release pretty` - print `<PRETTY_NAME>` if available, else `<NAME> <VERSION_ID>`
* `os-release family` - print `<ID_LIKE>` if present, else print `<ID>`
* options
    * `--qualify` - pre-pend "`wsl `" as relevant
        * WSL is identified by "WSL" being in the output of `uname -r`
    * `--lower-case`, `-l` - convert output to lower-case
* `os-release version` - print version of `os-release` query tool and help, exit with status zero

## Motivation

As a tool, it helps quickly identify a system type in a shell script, without needing to write `/etc/os-release` parsing and handlers.

Include it in `.bashrc` to display a welcome message:

```sh
echo "Welcome to $(os-release pretty)"
```

Use it in multi-platform shell scripts:

```sh
# Let `os-release` handle figuring out id/id_like values, etc
#   and ensuring a deterministic lower-case output

if [[ $(os-release family) = debian ]]; then
    # debian-like actions ...
    apt-get update && apt-get install -y htop

elif [[ $(os-release family) = fedora ]]; then
    # fedora-like actions
    if [[ $(os-release) -lt 31 ]]; then
        yum install htop
    else
        dnf install htop
    fi

else
    echo "$(os-release pretty) not supported"
fi
```
