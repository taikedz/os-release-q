package main

import (
	"flag"
	"fmt"
)

func Parse_args() {
	// var wordPtr = flag.String("word", "basic-word", "Some sort of help description")
	// var wordVar string
	// flag.StringVar(&wordVar, "word2", "basic-word", "Some sort of help description")
	flag.Parse()

	// fmt.Println("Got --word=", *wordPtr)
	// fmt.Println("Got --word2=", wordVar)

	for _, token := range flag.Args() {
		fmt.Println("-> ", token)
	}
}