package main

import (
    "fmt"
    "strings"
)

// The module name 'os-release' comes from go.mod
import "os-release/src/version"

func casePrintln(lowcase bool, message string) {
    if lowcase {
        message = strings.ToLower(message)
    }

    fmt.Println(message)
}

func main() {
    var ver_flag bool
    var lowcase bool
    var action string

    ver_flag, lowcase, action = get_action()

    if(ver_flag) {
        casePrintln(lowcase, app_name+" "+version.VERSION_TAG)
        return
    }

    osrel := loadOsRelease()

    switch action {
    case "":
        casePrintln(lowcase, strings.ToLower(osrel["ID"] + ":" + osrel["VERSION_ID"]) )

    case "id":
        casePrintln(lowcase, osrel["ID"])

    case "version":
        casePrintln(lowcase, osrel["VERSION_ID"])

    case "pretty":
        pretty, ok := osrel["PRETTY_NAME"]
        if ok {
            casePrintln(lowcase, pretty)
        } else {
            casePrintln(lowcase, osrel["NAME"] + " " + osrel["VERSION_ID"])
        }

    case "family":
        family, ok := osrel["ID_LIKE"]
        if ok {
            casePrintln(lowcase, strings.ToLower(family) )
        } else {
            casePrintln(lowcase, strings.ToLower(osrel["ID"]) )
        }

    case "container":
        var containers strings.Builder
        if checkUnameContains([]string{"-r"}, "WSL") {
            containers.WriteString("WSL ")
        }

        if !pidNameIn(1, []string{"init", "systemd"}) {
            containers.WriteString("Non-init")
        }

        casePrintln(lowcase, containers.String())

    default:
        casePrintln(lowcase, "Unknown action: " + action)
    }
}

