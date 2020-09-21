#!/bin/bash

#
# Initialise Zeppelin @ runtime.
# Note: Some vars are not enclosed in quotes (") because you get number format exceptions.
#

set -xe

cd /usr/local/zeppelin || exit

echo "Filling Zeppelin configuration templates"

function replace_env_config_if_not_exists {
  local conf_name=$1
  local envs_to_replace=$2
  if [ ! -r conf/"$conf_name" ]; then
    echo "$conf_name does not exist, creating it"
    envsubst $envs_to_replace < conf.templates/"$conf_name".template > conf/"$conf_name"
  else
    echo "$conf_name already exists, not overwriting"
  fi
}

function replace_env_config {
  local conf_name=$1
  local envs_to_replace=$2
  echo "creating $conf_name"
  envsubst $envs_to_replace < conf.templates/"$conf_name".template > conf/"$conf_name"
}

replace_env_config_if_not_exists interpreter.json
replace_env_config zeppelin-env.sh
replace_env_config zeppelin-site.xml
replace_env_config interpreter-list
replace_env_config log4j.properties
replace_env_config hive-site.xml

# Allow for multi-user or single-user setup
if [ -z "$ZEPPELIN_USER_TYPE" ]; then
  echo "Environment variable ZEPPELIN_USER_TYPE required, but not set, exiting ..."
  exit
else
  if [ "multiuser" == "$ZEPPELIN_USER_TYPE" ]; then
    echo "creating shiro.ini (multi-user)"
    cat conf.templates/shiro.ini.remoteuserauth.template > conf/shiro.ini
  else
    echo "creating shiro.ini (single-user)"
    replace_env_config shiro.ini '$ZEPPELIN_PASSWORD'
  fi
fi

# add zeppelin group if not exists
if [ -z "$ZEPPELIN_PROCESS_GROUP_NAME" ]; then
  echo "Environment variable ZEPPELIN_PROCESS_GROUP_NAME required, but not set, exiting ..."
  exit
elif [ -z "$ZEPPELIN_PROCESS_GROUP_ID" ]; then
  echo "Environment variable ZEPPELIN_PROCESS_GROUP_ID required, but not set, exiting ..."
  exit
elif getent group "$ZEPPELIN_PROCESS_GROUP_NAME"; then
  echo "Group $ZEPPELIN_PROCESS_GROUP_NAME already exists"
else
  echo "Group $ZEPPELIN_PROCESS_GROUP_NAME does not exist, creating it with gid=$ZEPPELIN_PROCESS_GROUP_ID"
  addgroup --force-badname -gid $ZEPPELIN_PROCESS_GROUP_ID "$ZEPPELIN_PROCESS_GROUP_NAME"
fi

# add zeppelin user if not exists
if [ -z "$ZEPPELIN_PROCESS_USER_NAME" ]; then
  echo "Environment variable ZEPPELIN_PROCESS_USER_NAME required, but not set, exiting ..." 
  exit
elif [ -z "$ZEPPELIN_PROCESS_USER_ID" ]; then
  echo "Environment variable ZEPPELIN_PROCESS_USER_ID required, but not set, exiting ..."
  exit
elif id -u "$ZEPPELIN_PROCESS_USER_NAME" 2>/dev/null; then
  echo "User $ZEPPELIN_PROCESS_USER_NAME already exists"
else
  echo "User $ZEPPELIN_PROCESS_USER_NAME does not exist, creating it with uid=$ZEPPELIN_PROCESS_USER_ID"
  adduser --force-badname "$ZEPPELIN_PROCESS_USER_NAME" --uid $ZEPPELIN_PROCESS_USER_ID --gecos "" --ingroup "$ZEPPELIN_PROCESS_GROUP_NAME" --disabled-login --disabled-password
fi 

# adjust ownership of the zeppelin folder
chown -R "$ZEPPELIN_PROCESS_USER_NAME" ../zeppelin
chgrp -R "$ZEPPELIN_PROCESS_GROUP_NAME" ../zeppelin
chown -R "$ZEPPELIN_PROCESS_USER_NAME" /hive
chgrp -R "$ZEPPELIN_PROCESS_GROUP_NAME" /hive
chown -R "$ZEPPELIN_PROCESS_USER_NAME" /home/"$ZEPPELIN_PROCESS_USER_NAME"
chgrp -R "$ZEPPELIN_PROCESS_GROUP_NAME" /home/"$ZEPPELIN_PROCESS_USER_NAME"

exec sudo -u "$ZEPPELIN_PROCESS_USER_NAME" -E -H env "PATH=$PATH" bin/zeppelin.sh
