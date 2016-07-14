#!/bin/bash
cd /usr/local/zeppelin

echo "Filling Zeppelin configuration templates"
cat conf/interpreter.json.template | envsubst > conf/interpreter.json
cat conf/zeppelin-env.sh.template | envsubst > conf/zeppelin-env.sh
cat conf/zeppelin-site.xml.template | envsubst > conf/zeppelin-site.xml
cat conf/shiro.ini.template | envsubst > conf/shiro.ini

# add zeppelin group if not exists
if getent group $ZEPPELIN_PROCESS_GROUP_NAME; then
  echo "Group $ZEPPELIN_PROCESS_GROUP_NAME already exists"
else
  echo "Group $ZEPPELIN_PROCESS_GROUP_NAME does not exist, creating it with gid=$ZEPPELIN_PROCESS_GROUP_ID"
  addgroup -gid $ZEPPELIN_PROCESS_GROUP_ID $ZEPPELIN_PROCESS_GROUP_NAME
fi

# add zeppelin user if not exists
if id -u $ZEPPELIN_PROCESS_USER_NAME 2>/dev/null; then
  echo "User $ZEPPELIN_PROCESS_USER_NAME already exists"
else
  echo "User $ZEPPELIN_PROCESS_USER_NAME does not exist, creating it with uid=$ZEPPELIN_PROCESS_USER_ID"
  adduser $ZEPPELIN_PROCESS_USER_NAME --uid $ZEPPELIN_PROCESS_USER_ID --gecos "" --ingroup $ZEPPELIN_PROCESS_GROUP_NAME --disabled-login --disabled-password
fi 

# adjust ownership of the zeppelin folder
chown -R $ZEPPELIN_PROCESS_USER_NAME *
chgrp -R $ZEPPELIN_PROCESS_GROUP_NAME *

exec sudo -u $ZEPPELIN_PROCESS_USER_NAME bin/zeppelin.sh
