#!/bin/sh
# SPDX-License-Identifier: EUPL-1.2
# Release notes on stdout. Usage: sh release-notes.sh TAG COMMIT GO_VERSION
set -eu
[ "$#" -eq 3 ] || { printf 'usage: sh release-notes.sh TAG COMMIT GO_VERSION\n' >&2; exit 2; }
tag=$1; commit=$2; gover=$3
prev=$(git tag --merged "$commit^" --list 'v*' --sort=-version:refname 2>/dev/null |
	grep -E '^v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$' | grep -vx "$tag" | head -n 1 || true)
printf 'Spike %s (throwaway rehearsal)\n\nCommit: %s\nBuilt with Go %s, CGO disabled, -trimpath.\n\n' "$tag" "$commit" "$gover"
printf 'Verify: `gh attestation verify ARCHIVE --repo wstein/stw-release-spike` and `sha256sum --check --ignore-missing SHA256SUMS`.\n\n'
if [ -z "$prev" ]; then printf '## Changes\n\nFirst release.\n'; exit 0; fi
printf '## Changes since %s\n\n' "$prev"
git log --no-merges --format='- %s (%h)' "$prev..$commit"
