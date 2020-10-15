#!/bin/sh
set -e

dir=$(cd "$(dirname "$0")" && pwd)
cd "$dir"

CHEERPJ_EXEC="$CHEERPJ_HOME/cheerpjfy.py"
test -f "$CHEERPJ_EXEC" || {
  >&2 echo "Please set CHEERPJ_HOME to your CheerpJ installation."
  exit 1
}

# Install cheerpj-dom.jar
mvn install:install-file -Dfile=${CHEERPJ_HOME}/cheerpj-dom.jar -DgroupId=com.learningtech -DartifactId=cheerpj-dom -Dversion=1.0 -Dpackaging=jar

mvn clean package dependency:copy-dependencies
mainjar=imagej2-cheerpj-0-SNAPSHOT.jar

jardir=target/dependency
logdir="$dir/target/cheerpj-logs"
distdir=target/dist

cp "target/$mainjar" "$jardir"
mkdir -p "$logdir"

# HACK: Remove ij.IJ before cheerpjfying, to avoid Javassist issues.
ij1=$(echo "$jardir/"ij-1.*.jar)
backup="$ij1.original"
cp "$ij1" "$backup"
zip -d "$ij1" ij/IJ.class

# TODO: `find src/main/java -type f` and remove all non-io.imjoy.imagej2
# classes from every JAR being processed, in the same way we remove ij.IJ.
# So this needs to be done in the for loop. Also, we don't want to backup
# and restore the original JAR files, because we really don't want the
# unpatched classes visible in any way.
# HACK: For now we hardcode.
zip -d "$jardir/"imagej-2.*.jar net/imagej/Main.class

# Run the CheerpJ build.
WORKDIR=./target/cheerpj_workdir
[ -d "$WORKDIR" ] && {
  rm -rf "$WORKDIR"
}
mkdir -p "$WORKDIR"

numdeps=$(ls "$jardir"/*.jar | wc -l | xargs)
dep=0
for f in "$jardir"/*.jar
do
  dep=$((dep+1))
  echo "Processing ${f##*/} ($dep/$numdeps)"

  mv "$f" "$f.moved"
  deps=$(echo "$jardir"/*.jar | tr ' ' ':')
  mv "$f.moved" "$f"

  logfile="$logdir/$(basename "${f%.jar}").log"
  $CHEERPJ_EXEC --deps="$deps" --work-dir="$WORKDIR" -j 10 "$f" >"$logfile" 2>&1
done
rm -rf "$WORKDIR"

# HACK: Restore ij.IJ class.
mv -f "$backup" "$ij1"

cp -rp dist "$distdir"
mv "$jardir/"* "$distdir"
rmdir "$jardir"

# Splice in the dependencies list to index.html.
mv "$distdir/$mainjar" "$distdir/$mainjar.moved"
args="/app/$mainjar:/app/$(cd "$distdir" && echo *.jar | sed 's_ _:/app/_g')"
mv "$distdir/$mainjar.moved" "$distdir/$mainjar"
sed "s;__JARS__;$args;" "$distdir/index.html" > "$distdir/index.html.new"
mv -f "$distdir/index.html.new" "$distdir/index.html"

ls "$distdir"
