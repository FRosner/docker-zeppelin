#!/bin/sh
cd /usr/local/zeppelin

cat conf/interpreter.json.template | envsubst > conf/interpreter.json
cat conf/zeppelin-env.sh.template | envsubst > conf/zeppelin-env.sh
cat conf/zeppelin-site.xml.template | envsubst > conf/zeppelin-site.xml

exec bin/zeppelin.sh
