#!/bin/bash
H2=h2-2014-01-18.zip
SQL_SCRIPT=sad-sanfom-ds.sql
BUILD_DIR=h2-build
OUTPUT_DIR=./
OUTPUT=sad-sanfom-ds

if [ ! -f "$BUILD_DIR/$H2" ]; then
  mkdir -p $BUILD_DIR
  curl https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/h2database/$H2 -o $BUILD_DIR/$H2
fi

if [ ! -d "$BUILD_DIR/h2" ]; then
  pushd . 
  unzip -qo $BUILD_DIR/$H2 -d $BUILD_DIR \
  && chmod +x $BUILD_DIR/h2/build.sh \
  && cd $BUILD_DIR/h2 \
  && ./build.sh &> /dev/null \
  && java -cp bin/h2-1.3.175.jar org.h2.tools.RunScript -url jdbc:h2:../$OUTPUT -script ../../$SQL_SCRIPT  -user sa  -password sa 
  popd 
fi 

if [ -f "$OUTPUT_DIR/$OUTPUT.h2.db" ]; then
  read -p "File $OUTPUT.h2.db already exists, are you sure you want to overwrite it? [y/n]" -n 1 -r
fi

if [[ $REPLY =~ ^[Yy]$ ]] || [ ! -f "$OUTPUT_DIR/$OUTPUT.h2.db" ]
then
  cp -v $BUILD_DIR/$OUTPUT.h2.db $OUTPUT_DIR
fi

rm -rf ./h2-build
