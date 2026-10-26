#!/bin/sh
# SPDX-License-Identifier: EUPL-1.2
# Exercise a shipped archive on its host. Usage: sh release-smoke.sh VERSION ARCHIVE
# ARCHIVE is spike_<version>_<os>_<arch>.tar.gz next to its .sha256 sidecar.
set -eu
fail() { printf 'release-smoke: %s\n' "$*" >&2; exit 1; }
[ "$#" -eq 2 ] || { printf 'usage: sh release-smoke.sh VERSION ARCHIVE\n' >&2; exit 2; }
version=$1; archive=$2
[ -f "$archive" ] || fail "archive not found: $archive"
archive=$(cd "$(dirname "$archive")" && pwd)/$(basename "$archive")
file=$(basename "$archive"); name=${file%.tar.gz}
[ -f "$archive.sha256" ] || fail "checksum sidecar missing"
if command -v sha256sum >/dev/null 2>&1; then
	(cd "$(dirname "$archive")" && sha256sum -c "$file.sha256" >/dev/null) || fail "checksum mismatch"
else
	(cd "$(dirname "$archive")" && shasum -a 256 -c "$file.sha256" >/dev/null) || fail "checksum mismatch"
fi
d=$(mktemp -d); trap 'rm -rf "$d"' EXIT
tar -xzf "$archive" -C "$d" || fail "cannot extract"
members=$(cd "$d" && find . -mindepth 1 | LC_ALL=C sort | tr '\n' ' ')
[ "$members" = "./$name ./$name/README.md ./$name/spike " ] || fail "unexpected members: $members"
got=$("$d/$name/spike" version) || fail "spike version failed"
[ "$got" = "spike $version" ] || fail "spike version printed '$got', want 'spike $version'"
[ "$("$d/$name/spike" hello)" = "hello from spike" ] || fail "spike hello printed the wrong text"
printf 'release-smoke: %s ok\n' "$file"
