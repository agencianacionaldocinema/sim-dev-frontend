#!/bin/bash
mvn install -DskipTests -f $SRC_BUILD_DIR/sin-bpm/pom.xml \
&& mvn install -DskipTests -f $SRC_BUILD_DIR/ancine-api/ancine-api/pom.xml \
&& mvn install -DskipTests -f $SRC_BUILD_DIR/sin/sin/pom.xml \
&& cp $SRC_BUILD_DIR/sin/sin/sin-ear/target/sin-ear-0.0.1.ear $SRC_OUTPUT_DIR

/opt/jboss/create-sim-kieserver-container.sh &

$JBOSS_HOME/bin/standalone.sh -c standalone.xml -b 0.0.0.0 -bmanagement 0.0.0.0 
