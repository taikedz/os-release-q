package main

import (
    "os"
)

func stderr_exit(code int, message string) {
    os.Stderr.WriteString(message+"\n")
    os.Exit(code)
}

