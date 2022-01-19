#!/bin/sh
set -e

entrypoint_args="$@"

container_env_file=/stroom-log-sender/container.env
# This is the file in the bind mounted volume with the env vars in it
crontab_file=/stroom-log-sender/config/crontab.txt
# This is the transient one with the env vars replaced
crontab_substituted_file=/stroom-log-sender/crontab_subst.txt

# Re-set permission to the `sender` user if current user is root
# This avoids permission denied if the data volume is mounted by root

# dump the environment variables
echo "Dumping environment variables"
echo "----------------------------------------------------------"
env \
| uniq \
| sort
echo "----------------------------------------------------------"

#chown sender:sender /stroom-log-sender/log-volumes

echo "running command: '$entrypoint_args'"

# If current user is root
if [ "$(id -u)" = '0' ]; then
  # run the COMMAND as user 'sender'
  echo "user is root"
  exec su-exec sender "$@"
fi

exec "$@"