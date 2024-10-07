# `os-release` query

A basic tool to print specific `/etc/os-release` details and other checks.

## Install

Run `./install.sh 0.2.0` to install from web. Requires `curl`

Run `./install.sh` to build and install. Requires `go` and `make`

## Design

The following is intended to be the full set of operations:

* `os-release` - print `<ID>:<VERSION_ID>`
* `os-release id` print `<ID>`
* `os-release version` - print `<VERSION_ID>`
* `os-release pretty` - print `<PRETTY_NAME>` if available, else `<NAME> <VERSION_ID>`
* `os-release family` - print `<ID_LIKE>` if present, else print `<ID>`
* `os-release container` - print `WSL`, and/or `Non-init` as relevant
    * WSL is identified by "WSL" being in the output of `uname -r`
    * Containerisation is identified by checking PID 1, and noting it being other than `init` or `systemd`. This is not necessarily reliable.
* options
    * `-l` - convert output to lower-case
    * `-v` - print version of `os-release` query tool and help, exit with status zero

## Motivation

As a tool, it helps quickly identify a system type in a shell script, without needing to write /etc/os-release parsing and handlers or polluting a script's variables through sourcing.

Include it in .bashrc to display a welcome message:

```sh
echo "Welcome to $(os-release pretty)"
```

Use it in multi-platform shell scripts:

```sh
# Let `os-release` handle figuring out id/id_like values, etc
#   and ensuring lower-case output

# e.g. Linux Mint has "ubuntu debian" here, whereas CentOS has "rhel fedora" here
# and Ubuntu just has "debian"
FAM="$(os-release -l family)"

if [[ "$FAM" =~ debian ]]; then
    # debian-like actions ...
    apt-get update && apt-get install -y htop

elif [[ "$FAM" =~ fedora ]]; then
    # fedora-like actions
    if [[ $(os-release version) -lt 22 ]]; then
        yum install htop
    else
        dnf install htop
    fi

else
    echo "$(os-release pretty) not supported"
fi
```
