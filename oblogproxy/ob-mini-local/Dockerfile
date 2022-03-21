FROM oceanbase/centos7:latest

ARG OB_VERSION=3.1.1
ARG OB_LOG_PROXY_VERSION=1.0.0

ENV OB_HOME_PATH "/root/ob"
ENV OB_CLUSTER_NAME "mini-ce"
ENV OB_ROOT_PASSWORD "pswd"

WORKDIR /root/boot/

RUN yum-config-manager --add-repo https://mirrors.aliyun.com/oceanbase/OceanBase.repo && yum install -y ob-deploy obclient \
    && rm -rf /usr/obd/mirror/remote/* && yumdownloader oceanbase-ce-libs-${OB_VERSION} oceanbase-ce-${OB_VERSION} && obd mirror clone *.rpm \
    && yum install -y oceanbase-ce-libs-*.rpm oceanbase-ce-utils-${OB_VERSION} oceanbase-ce-devel-${OB_VERSION} libaio* oblogproxy-${OB_LOG_PROXY_VERSION} \
    && rm -f *.rpm /usr/local/oblogproxy/conf/conf.json && yum clean all

COPY boot /root/boot/
EXPOSE 2881 2882 2983
CMD /root/boot/boot.sh
