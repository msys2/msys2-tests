#!/bin/bash

set -e

TEMPDIR=$(mktemp -d)
trap 'rm -rf "$TEMPDIR"' EXIT

mkdir -p "$TEMPDIR/docs/subdir"

cat > "$TEMPDIR/docs/index.adoc" <<'EOF'
= Test Document

include::subdir/first.adoc[]
EOF

cat > "$TEMPDIR/docs/subdir/first.adoc" <<'EOF'
This content comes from the included file.
EOF

asciidoctor -D "$TEMPDIR/out" "$TEMPDIR/docs/index.adoc"

[[ -f "$TEMPDIR/out/index.html" ]]
grep -q 'This content comes from the included file\.' "$TEMPDIR/out/index.html"
