#!/bin/bash
cd /usr/local/zeppelin

# fill configuration templates
cat conf/interpreter.json.template | envsubst > conf/interpreter.json
cat conf/zeppelin-env.sh.template | envsubst > conf/zeppelin-env.sh
cat conf/zeppelin-site.xml.template | envsubst > conf/zeppelin-site.xml
cat conf/shiro.ini.template | envsubst > conf/shiro.ini

# add zeppelin group if not exists
if getent group $ZEPPELIN_PROCESS_GROUP; then
  echo "Group $ZEPPELIN_PROCESS_GROUP already exists"
else
  echo "Group $ZEPPELIN_PROCESS_GROUP does not exist, creating it"
  addgroup $ZEPPELIN_PROCESS_GROUP
fi

# add zeppelin user if not exists
if id -u $ZEPPELIN_PROCESS_USER 2>/dev/null; then
  echo "User $ZEPPELIN_PROCESS_USER already exists"
else
  echo "User $ZEPPELIN_PROCESS_USER does not exist, creating it"
  adduser $ZEPPELIN_PROCESS_USER --gecos "" --ingroup $ZEPPELIN_PROCESS_GROUP --disabled-login --disabled-password
fi 

# adjust ownership of the zeppelin folder
chown -R $ZEPPELIN_PROCESS_USER *
chgrp -R $ZEPPELIN_PROCESS_GROUP *

exec sudo -u $ZEPPELIN_PROCESS_USER bin/zeppelin.sh
