package main

import (
    "os/exec"
    "strings"
)

func checkUnameContains(uname_options []string, desired_content string) bool {
    out, err := exec.Command("uname", uname_options...).Output()
    if err != nil {
        stderr_exit(100, "Failed 'uname' execution "+string(err.Error()))
    }

    return strings.Contains(string(out), desired_content)
}
