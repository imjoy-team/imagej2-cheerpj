#!/bin/sh

set -e

dir=$(dirname "$0")
distdir="$dir/target/dist"
test -d "$distdir" || {
  >&2 echo "Please run ./build.sh first."
  exit 1
}
cd "$distdir"
python3 -m http.server 9999
echo "Server running on http://localhost:9999"
