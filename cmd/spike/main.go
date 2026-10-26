// SPDX-License-Identifier: EUPL-1.2

// Command spike is a throwaway CLI used to rehearse the stw release flow.
package main

import (
	"fmt"
	"io"
	"os"
	"strings"
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
		if len(args) == 4 && args[1] == "--name" && args[3] == "--shout" {
			fmt.Fprintf(stdout, "%s\n", strings.ToUpper("hello, "+args[2]))
			break
		}
		if len(args) == 3 && args[1] == "--name" {
			fmt.Fprintf(stdout, "hello, %s\n", args[2])
			break
		}
		fmt.Fprintln(stdout, "hello from spike")
	default:
		fmt.Fprintf(stderr, "spike: unknown command %q\n", args[0])
		return 2
	}
	return 0
}
