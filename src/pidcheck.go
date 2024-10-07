package main

import (
    "strings"
)

func pidName(pid int) string {
    cmd_name := readFileLines("/proc/1/cmdline")[0]
    base_path := strings.Split(cmd_name, " ")
    name := strings.Split(base_path[0], "/")

    // Somehow the read-in string has null-byte termination - trim it
    return strings.Trim(name[len(name)-1] , "\x00" )
}

func pidNameIn(pid int, targets []string) bool {
    name := pidName(pid)

    for _, target := range(targets) {
        if name == target {
            return true
        }
    }

    return false
}
