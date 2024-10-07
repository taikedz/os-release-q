package main

import (
	"flag"
	"fmt"
	"os"
)

func get_action() (bool, bool, string) {
    /* This library is a little simplistic - the option flags MUST come before the positional args
     *
     * So
     *     os-release -qualify id
     * is not the same as
     *     os-release id -qualify
     *
     * In the second form, `-qualify` becomes a literal positional argument
     *
     * The `-h` flag is implemented by default and mentions flags, but not positional arguments, as they
     *   cannot seem to be documented ...
     */
	var version bool
    var lowcase bool
	flag.BoolVar(&version, "v", false, "Whether to print the program name and version, and exit")
	flag.BoolVar(&lowcase, "l", false, "Whether to force output to lower case")

	flag.Parse()
	
	var tokens = flag.Args()

	if len(tokens) == 0 {
		return version, false, ""
	} else if len(tokens) > 1 {
		// Error out ?
		fmt.Println("Too many arguments :", tokens)
        fmt.Println("Expecting either of")
        fmt.Println("    "+app_name+" [-low] <action>")
        fmt.Println("    "+app_name+" -version")
        fmt.Println("(remember to specify option flags before the <action>)")
		os.Exit(1)
	}

	return version, lowcase, tokens[0]
}
