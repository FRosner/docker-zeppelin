#!/bin/bash
cd /usr/local/zeppelin

echo "Filling Zeppelin configuration templates"
function replace_env_config {
  local conf_name=$1
  if [ ! -r conf/$conf_name ]; then
    echo "$conf_name does not exist, creating it"
    cat conf.templates/$conf_name.template | envsubst > conf/$conf_name
  else
    echo "$conf_name already exists, not overwriting"
  fi
}

for conf in interpreter.json zeppelin-env.sh zeppelin-site.xml shiro.ini interpreter-list log4j.properties; do
  replace_env_config $conf
done

# add zeppelin group if not exists
if getent group $ZEPPELIN_PROCESS_GROUP_NAME; then
  echo "Group $ZEPPELIN_PROCESS_GROUP_NAME already exists"
else
  echo "Group $ZEPPELIN_PROCESS_GROUP_NAME does not exist, creating it with gid=$ZEPPELIN_PROCESS_GROUP_ID"
  addgroup --force-badname -gid $ZEPPELIN_PROCESS_GROUP_ID $ZEPPELIN_PROCESS_GROUP_NAME
fi

# add zeppelin user if not exists
if id -u $ZEPPELIN_PROCESS_USER_NAME 2>/dev/null; then
  echo "User $ZEPPELIN_PROCESS_USER_NAME already exists"
else
  echo "User $ZEPPELIN_PROCESS_USER_NAME does not exist, creating it with uid=$ZEPPELIN_PROCESS_USER_ID"
  adduser --force-badname $ZEPPELIN_PROCESS_USER_NAME --uid $ZEPPELIN_PROCESS_USER_ID --gecos "" --ingroup $ZEPPELIN_PROCESS_GROUP_NAME --disabled-login --disabled-password
fi 

# adjust ownership of the zeppelin folder
chown -R $ZEPPELIN_PROCESS_USER_NAME *
chgrp -R $ZEPPELIN_PROCESS_GROUP_NAME *

exec sudo -u $ZEPPELIN_PROCESS_USER_NAME bin/zeppelin.sh
