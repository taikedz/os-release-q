package main

import (
	"flag"
	"fmt"
	"os"
)

func get_action() (bool, string) {
    /* This library is a little stupid - the option flags MUST come before the positional args
     *
     * So
     *     os-release -qualify id
     * is not the same as
     *     os-release id -qualify
     *
     * In the second form, `-qualify` becomes a literal positional argument
     */
	var qualify bool
	flag.BoolVar(&qualify, "qualify", false, "Whether to add a qualifier if non-Linux native (e.g. WSL)")

	flag.Parse()
	
	var tokens = flag.Args()

	if len(tokens) == 0 {
		return qualify, ""
	} else if len(tokens) > 1 {
		// Error out ?
		fmt.Println("Too many arguments :", tokens)
        fmt.Println("Expecting")
        fmt.Println("    "+app_name+" [-qualify] <action>")
        fmt.Println("(remember to specify option flags before the <action>)")
		os.Exit(1)
	}

	return qualify, tokens[0]
}
