#!/bin/bash

cd "$(dirname "$0")" || exit

LOG_PROXY_HOME="/usr/local/oblogproxy"
LOG_PROXY_CONF="$LOG_PROXY_HOME/conf/conf.json"
LOG_PROXY_CONF_TEMPLATE="conf-template.json"

TIMESTAMP="$(date +%s)"

[[ -f "$LOG_PROXY_CONF" ]] && echo "find $LOG_PROXY_CONF, skip configuring..." || {
  echo "generate $LOG_PROXY_CONF ..."
  TEMP="$LOG_PROXY_CONF_TEMPLATE-$TIMESTAMP"
  cp -f "$LOG_PROXY_CONF_TEMPLATE" "$TEMP"
  ENCRYPTED_SYS_USERNAME=$("$LOG_PROXY_HOME"/bin/logproxy -x "$OB_SYS_USERNAME")
  ENCRYPTED_SYS_PASSWORD=$("$LOG_PROXY_HOME"/bin/logproxy -x "$OB_SYS_PASSWORD")
  sed -i "s|@ENCRYPTED_SYS_USERNAME@|$ENCRYPTED_SYS_USERNAME|g" "$TEMP"
  sed -i "s|@ENCRYPTED_SYS_PASSWORD@|$ENCRYPTED_SYS_PASSWORD|g" "$TEMP"
  mv -f "$TEMP" "$LOG_PROXY_CONF"
}

[[ -f "$LOG_PROXY_CONF" ]] && {
  echo "start ob log proxy ..."
  cd "$LOG_PROXY_HOME" || exit
  bash ./run.sh start
} && echo "boot success!" && exec /sbin/init
