package main

import (
    "os"
    "bufio"
)

func readFileLines(path string) []string {
    var lines []string

    fh, err := os.Open(path)
    if err != nil {
        stderr_exit(1 , "Could not open "+path)
    }

    fileScanner := bufio.NewScanner(fh)
    fileScanner.Split(bufio.ScanLines)

    for fileScanner.Scan() {
        ln := fileScanner.Text()
        if ! (len(ln) == 0 || ln[0] == '#') {
            lines = append(lines, ln)
        }
    }

    fh.Close()

    return lines
}


