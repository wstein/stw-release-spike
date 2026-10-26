#!/bin/sh
# SPDX-License-Identifier: EUPL-1.2
# Build and package one target for `stw release build` (contract build "cli").
# Usage: sh scripts/release-build.sh OS ARCH VERSION OUTPUT   (env: CGO_ENABLED, GOOS, GOARCH, GOTOOLCHAIN, GOFLAGS)
set -eu
[ "$#" -eq 4 ] || { printf 'usage: sh release-build.sh OS ARCH VERSION OUTPUT\n' >&2; exit 2; }
os=$1; arch=$2; version=$3; output=$4
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
go build -trimpath -buildvcs=false -ldflags "-X main.version=$version" -o "$tmp/spike" ./cmd/spike
SOURCE_DATE_EPOCH=$(git log -1 --format=%ct) sh scripts/release-package.sh "$version" "${os}_${arch}" "$tmp/spike" "$(dirname "$output")" >/dev/null
test -f "$output"
