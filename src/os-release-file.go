package main

import (
    "os-release/src/envreader"
)


func loadOsRelease() map[string]string {
    lines := readFileLines("/etc/os-release")
    return envreader.ConvertEnvStringsToMap(lines)
}

