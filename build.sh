#!/bin/sh
#
# Build script for basic.css
#
#

BUILD_FILE="build/basic.min.css"

rm -rf build/*.css

for cssFile in src/*.css
do
  echo "css: $cssFile"
  cat "$cssFile" >> "$BUILD_FILE"
done
