#!/bin/bash
#
# Build script for basic.css
# Invoke: ./build.sh zip
# 
# Running ./build.sh just generates build/basic.min.css 
# Running ./build.sh zip does the same above, but makes a zip archive

TEMP_FILE="build/temp.css"
BUILD_BASE_FILE="build/basic.min.css"
BUILD_ALL_FILE="build/basic.all.min.css"

# skip the files that end with `--extras.css` when generating the base build
BASE_CSS=`/bin/ls --ignore="*--extras.css" src`
ALL_CSS=`/bin/ls src`

## awk script to remove comments from the css file
#https://stackoverflow.com/questions/48344193/removing-css-comments-with-grep
#https://stackoverflow.com/questions/15020000/embedding-awk-in-a-shell-script
################################
# AWK scripts                  #
################################
read -d '' cssCommentRemover << 'EOF'
function remComm() {
   if ( !m )
      m = index($0, cs);

   if ( m && p = index($0, ce) ) {
      $0 = substr($0, 1, m-1) substr($0, p+2);
      if (m = index($0, cs))
         remComm();
   }
}
BEGIN {
   cs="/*";
   ce="*/";
   m = 0;
}
{
   remComm();
   if ( !m && NF )
      print;
}
EOF
################################
# End of AWK Scripts           #
################################

# clear old build and zip files
rm -rf build/*.css
rm -rf build/*.zip

build_css () {
  if [ -f "TEMP_FILE" ]
  then
    rm "$TEMP_FILE"
  fi

  # for every css file, nuke the comments
  for cssFile in "$1"
  do
    echo "css: $cssFile"
    awk "$cssCommentRemover" "src/$cssFile" | tr -s ' ' >> "$TEMP_FILE"
  done
  
  # make everything in oneline
  cat "$TEMP_FILE" | tr -d '\n' >> "$2"
  
  # remove temp files
  rm "$TEMP_FILE"
  
  # make foo {}
  # into foo{}
  sed -i 's/\ {/{/g' "$2"
  # make foo{ prop into foo{prop
  sed -i 's/{ /{/g' "$2"
  # make prop: value into prop:value
  sed -i 's/:\ /:/g' "$2"
  sed -i 's/;\ /;/g' "$2"
  
  # finding gz size of the bundle now
  GZ_SIZE=$(gzip -9 -c "$2" | wc -c | numfmt --to=iec-i --suffix=B)
  echo "Bundle size after gz is: $GZ_SIZE"
}

build_css "$BASE_CSS" "$BUILD_BASE_FILE"
build_css "$ALL_CSS" "$BUILD_ALL_FILE"

# do we need to make a zip file
if [ "$1" == "zip" ]
then
  zip basic.css.zip build/basic.min.css src/*.css docs.css favicon.ico index.html
  mv basic.css.zip build/.
  echo "Made zip file"
  echo "Check build folder"
fi




