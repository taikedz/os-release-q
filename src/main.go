package main

import "fmt"

// The module name 'os-release' comes from go.mod
import "os-release/src/version"

func main() {
    var qualify bool
    var action string
    qualify, action = get_action()

    if qualify {
        fmt.Println("Qualify me")
    }

    switch action {
    case "":
        fmt.Println(app_name, version.VERSION_TAG)
    case "id":
        fmt.Println("Not implemented")
    default:
        fmt.Println("Unknown action", action)
    }
}
