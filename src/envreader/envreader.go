package envreader

import (
    "strings"
)

func ConvertEnvStringsToMap(env_strings []string) map[string]string {
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

