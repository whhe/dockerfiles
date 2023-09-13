#!/bin/bash
################################################################################
#  Licensed to the Apache Software Foundation (ASF) under one
#  or more contributor license agreements.  See the NOTICE file
#  distributed with this work for additional information
#  regarding copyright ownership.  The ASF licenses this file
#  to you under the Apache License, Version 2.0 (the
#  "License"); you may not use this file except in compliance
#  with the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

cd "$(dirname "$0")" || exit

LOG_PROXY_HOME="/usr/local/oblogproxy"
LOG_PROXY_CONF="$LOG_PROXY_HOME/conf/conf.json"
LOG_PROXY_CONF_TEMPLATE="conf-template.json"

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$LOG_PROXY_HOME/liboblog

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
  echo "start oblogproxy ..."
  cd "$LOG_PROXY_HOME" || exit
  bash ./run.sh start
} && echo "boot success!" && exec /sbin/init
