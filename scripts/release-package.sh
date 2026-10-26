#!/bin/sh
# SPDX-License-Identifier: EUPL-1.2
# Package one release binary reproducibly.
# Usage: SOURCE_DATE_EPOCH=N sh scripts/release-package.sh VERSION TARGET BINARY OUTDIR
# TARGET is <os>_<arch>. Writes OUTDIR/spike_<version without v>_<target>.tar.gz and a .sha256 sidecar.
set -eu
fail() { printf 'release-package: %s\n' "$*" >&2; exit 1; }
[ "$#" -eq 4 ] || { printf 'usage: SOURCE_DATE_EPOCH=N sh release-package.sh VERSION TARGET BINARY OUTDIR\n' >&2; exit 2; }
version=$1; target=$2; binary=$3; out=$4
printf '%s\n' "$version" | grep -Eq '^v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(-[0-9A-Za-z.]+)?$' || fail "bad version: $version"
printf '%s\n' "$target" | grep -Eq '^(linux|darwin)_[a-z0-9]+$' || fail "bad target: $target"
: "${SOURCE_DATE_EPOCH:?release-package: SOURCE_DATE_EPOCH is required}"
[ -f "$binary" ] || fail "binary not found: $binary"
[ -f README.md ] || fail "README.md not found in $(pwd)"
tar --version 2>/dev/null | grep -q 'GNU tar' || fail "GNU tar is required"
name=spike_${version#v}_${target}
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
mkdir "$work/$name"
cp "$binary" "$work/$name/spike"
cp README.md "$work/$name/"
chmod 0755 "$work/$name" "$work/$name/spike"
chmod 0644 "$work/$name/README.md"
mkdir -p "$out"
out=$(cd "$out" && pwd)
archive=$out/$name.tar.gz
rm -f "$archive"
tar --sort=name --owner=0 --group=0 --numeric-owner --mtime="@$SOURCE_DATE_EPOCH" \
	--format=ustar -C "$work" -cf - "$name" | gzip -n -9 >"$archive"
(cd "$out" && sha256sum "$name.tar.gz" >"$name.tar.gz.sha256")
printf '%s\n' "$archive"
