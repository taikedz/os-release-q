package main

import (
    "bufio"
    "os"
    "strings"
)


func loadOsRelease() map[string]string {
    lines := readFileLines("/etc/os-release")
    return convertEnvStringsToMap(lines)
}


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
        if ! (ln[0] == '#' || len(ln) == 0) {
            lines = append(lines, ln)
        }
    }

    fh.Close()

    return lines
}

func convertEnvStringsToMap(env_strings []string) map[string]string {
    // Go over string, split along first '=', register key->val and then return the map
    // and return the
    env_lookup := make(map[string]string)

    for _,line := range env_strings {
        tokens := strings.SplitN(line, "=", 2)
        k := tokens[0]
        v := tokens[1]

        if v[0] == '"' && v[len(v)-1] == '"' {
            v = v[1:len(v)-1]
        }
        env_lookup[k] = v
    }

    return env_lookup
}

