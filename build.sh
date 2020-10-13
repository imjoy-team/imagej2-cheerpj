#!/bin/sh
set -e

CHEERPJ_EXEC="$CHEERPJ_HOME/cheerpjfy.py"
test -f "$CHEERPJ_EXEC" || {
  >&2 echo "Please set CHEERPJ_HOME to your CheerpJ installation."
  exit 1
}

mvn clean package
jar=target/imagej2-cheerpj-0-SNAPSHOT-all.jar 

# HACK: Remove ij.IJ before cheerpjfying, to avoid Javassist issues.
backup="$jar.original"
cp "$jar" "$backup"
zip -d "$jar" ij/IJ.class

# Run the CheerpJ build.
"$CHEERPJ_EXEC" "$jar"

# HACK: Restore ij.IJ class.
mv "$backup" "$jar"

cp -rp dist target/dist
mv "$jar".js target/dist
