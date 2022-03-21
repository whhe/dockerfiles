#!/bin/bash

cd "$(dirname "$0")" || exit

CLUSTER_CONF="cluster.yaml"
CLUSTER_CONF_TEMPLATE="cluster-template.yaml"

LOG_PROXY_HOME="/usr/local/oblogproxy"
LOG_PROXY_CONF="$LOG_PROXY_HOME/conf/conf.json"
LOG_PROXY_CONF_TEMPLATE="conf-template.json"

TIMESTAMP="$(date +%s)"

[[ -f "$CLUSTER_CONF" ]] && echo "find $CLUSTER_CONF, skip configuring..." || {
  echo "generate $CLUSTER_CONF ..."
  TEMP="$CLUSTER_CONF_TEMPLATE-$TIMESTAMP"
  cp -f "$CLUSTER_CONF_TEMPLATE" "$TEMP"
  sed -i "s|@OB_HOME_PATH@|$OB_HOME_PATH|g" "$TEMP"
  sed -i "s|@OB_ROOT_PASSWORD@|$OB_ROOT_PASSWORD|g" "$TEMP"
  mv -f "$TEMP" "$CLUSTER_CONF"
  echo "create home path and deploy ob cluster ..."
  mkdir -p "$OB_HOME_PATH" && obd cluster deploy "$OB_CLUSTER_NAME" -c "$CLUSTER_CONF"
}

[[ -f $CLUSTER_CONF ]] && {
  echo "start ob cluster ..."
  obd cluster restart "$OB_CLUSTER_NAME"
  obclient -h127.0.0.1 -P2881 -uroot -p"$OB_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON *.* TO root@'%' WITH GRANT OPTION;"
}

[[ -f "$LOG_PROXY_CONF" ]] && echo "find $LOG_PROXY_CONF, skip configuring..." || {
  echo "generate $LOG_PROXY_CONF ..."
  TEMP="$LOG_PROXY_CONF_TEMPLATE-$TIMESTAMP"
  cp -f "$LOG_PROXY_CONF_TEMPLATE" "$TEMP"
  ENCRYPTED_ROOT_PASSWORD=$("$LOG_PROXY_HOME"/bin/logproxy -x "$OB_ROOT_PASSWORD")
  sed -i "s|@ENCRYPTED_ROOT_PASSWORD@|$ENCRYPTED_ROOT_PASSWORD|g" "$TEMP"
  mv -f "$TEMP" "$LOG_PROXY_CONF"
}

[[ -f "$LOG_PROXY_CONF" ]] && {
  echo "start ob log proxy ..."
  cd "$LOG_PROXY_HOME" || exit
  bash ./run.sh start
} && echo "boot success!" && exec /sbin/init

