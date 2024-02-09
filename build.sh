#!/bin/bash
#
# Build script for basic.css
#
#

TEMP_FILE="build/temp.css"
BUILD_FILE="build/basic.min.css"
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

# clear old build files
rm -rf build/*.css

# for every css file, nuke the comments
for cssFile in src/*.css
do
  echo "css: $cssFile"
  awk "$cssCommentRemover" "$cssFile" >> "$TEMP_FILE"
done

# make everything in oneline
cat "$TEMP_FILE" | tr -d '\n' >> "$BUILD_FILE"

# remove temp files
rm "$TEMP_FILE"

