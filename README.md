# `os-release` query

A basic tool to print specific `/etc/os-release` details and other checks.

The following is intended to be the full set of operations:

* `os-release` - print version of `os-release` query tool and help, exit `0`
* `os-release id` - print `<ID>:<VERSION_ID>` , lower case
* `os-release pretty` - print `<PRETTY_NAME>` if available, else `<NAME> <VERSION_ID>`
* `os-release family` - print `<ID_LIKE>` if present, else print `<ID>`, always lower case
* options
    * `--qualify` - pre-pend "`wsl `" or "`mingw `" as relevant
    * WSL is identified by environment vairable "WSLENV" being defined

## Motivation

Primarily, to learn Go (lang), and do some basic handling.

As a tool, it helps quickly identify a system type in a shell script, without needing to write `/etc/os-release` parsing and handlers.
