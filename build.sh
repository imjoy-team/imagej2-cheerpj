#!/bin/sh
set -e

CHEERPJ_EXEC="$CHEERPJ_HOME/cheerpjfy.py"
test -f "$CHEERPJ_EXEC" || {
  >&2 echo "Please set CHEERPJ_HOME to your CheerpJ installation."
  exit 1
}

# Install cheerpj-dom.jar
mvn install:install-file -Dfile=${CHEERPJ_HOME}/cheerpj-dom.jar -DgroupId=com.learningtech -DartifactId=cheerpj-dom -Dversion=1.0 -Dpackaging=jar

mvn clean
mvn -Pdeps package

jar=target/imagej2-cheerpj-0-SNAPSHOT-all.jar 

# HACK: Remove ij.IJ before cheerpjfying, to avoid Javassist issues.
backup="$jar.original"
cp "$jar" "$backup"
zip -d "$jar" ij/IJ.class

# Run the CheerpJ build.
WORKDIR=./target/cheerpj_workdir
[ -d "$WORKDIR" ] && {
  rm -rf "$WORKDIR"
}
mkdir -p "$WORKDIR"
"$CHEERPJ_EXEC" --work-dir="$WORKDIR" -j 4 "$jar"
rm -rf "$WORKDIR"

# HACK: Restore ij.IJ class.
mv "$backup" "$jar"

cp -rp dist target/dist
mv "$jar" target/dist
mv "$jar".js target/dist
