#!/bin/sh
cd /usr/local/zeppelin

cat conf/interpreter.json.template | envsubst > conf/interpreter.json
cat conf/zeppelin-env.sh.template | envsubst > conf/zeppelin-env.sh
cat conf/zeppelin-site.xml.template | envsubst > conf/zeppelin-site.xml
cat conf/shiro.ini.template | envsubst > conf/shiro.ini

exec bin/zeppelin.sh
