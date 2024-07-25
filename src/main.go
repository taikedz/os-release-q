package main

import "fmt"

// The module name 'os-release' comes from go.mod
import "os-release/src/version"

func main() {
    fmt.Println(app_name)
    fmt.Println(version.VERSION_TAG)
    Parse_args()
}
