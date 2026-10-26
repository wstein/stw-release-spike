// SPDX-License-Identifier: EUPL-1.2

package main

import (
	"bytes"
	"testing"
)

func TestRun(t *testing.T) {
	cases := []struct {
		args []string
		want string
		code int
	}{
		{[]string{"hello"}, "hello from spike\n", 0},
		{[]string{"hello", "--name", "Ada"}, "hello, Ada\n", 0},
		{[]string{"version"}, "spike dev\n", 0},
	}
	for _, c := range cases {
		var out, errb bytes.Buffer
		if code := run(c.args, &out, &errb); code != c.code || out.String() != c.want {
			t.Errorf("run(%v) = %d, %q; want %d, %q", c.args, code, out.String(), c.code, c.want)
		}
	}
}

func TestRunUnknown(t *testing.T) {
	var out, errb bytes.Buffer
	if code := run([]string{"nope"}, &out, &errb); code != 2 {
		t.Errorf("unknown command exit = %d, want 2", code)
	}
}
