package main

import (
    "fmt"
    "strings"
)

// The module name 'os-release' comes from go.mod
import "os-release/src/version"

func qualifiedPrint(qualify bool, message string) {
    var qualifier string = ""
    
    if qualify && checkUnameContains([]string{"-r"}, "WSL") {
        qualifier = "wsl "
    }

    fmt.Println(qualifier + message)
}

func main() {
    var qualify bool
    var action string

    qualify, action = get_action()

    switch action {
    case "":
        qualifiedPrint(qualify, app_name +" "+ version.VERSION_TAG)
    case "id":
        osrel := loadOsRelease()
        qualifiedPrint(qualify, strings.ToLower(osrel["ID"] + ":" + osrel["VERSION_ID"]) )
    case "pretty":
        osrel := loadOsRelease()
        pretty, ok := osrel["PRETTY_NAME"]
        if ok {
            qualifiedPrint(qualify, pretty)
        } else {
            qualifiedPrint(qualify, osrel["NAME"] + " " + osrel["VERSION_ID"])
        }
    case "family":
        osrel := loadOsRelease()
        family, ok := osrel["ID_LIKE"]
        if ok {
            qualifiedPrint(qualify, strings.ToLower(family) )
        } else {
            qualifiedPrint(qualify, strings.ToLower(osrel["ID"]) )
        }
    default:
        qualifiedPrint(qualify, "Unknown action: " + action)
    }
}
