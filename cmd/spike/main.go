// SPDX-License-Identifier: EUPL-1.2

// Command spike is a throwaway CLI used to rehearse the stw release flow.
package main

import (
	"fmt"
	"io"
	"os"
)

// version is stamped at build time with -ldflags "-X main.version=vX.Y.Z".
var version = "dev"

func main() {
	os.Exit(run(os.Args[1:], os.Stdout, os.Stderr))
}

func run(args []string, stdout, stderr io.Writer) int {
	if len(args) == 0 {
		fmt.Fprintln(stderr, "usage: spike version | hello")
		return 2
	}
	switch args[0] {
	case "version":
		fmt.Fprintf(stdout, "spike %s\n", version)
	case "hello":
		fmt.Fprintln(stdout, "hello from spike")
	default:
		fmt.Fprintf(stderr, "spike: unknown command %q\n", args[0])
		return 2
	}
	return 0
}
