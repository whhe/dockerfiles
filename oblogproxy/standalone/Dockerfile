FROM oceanbase/centos7:latest

ARG OB_LOG_PROXY_VERSION=1.0.0
ARG OB_LIB_VERSION=3.1.1

ENV OB_SYS_USERNAME "user"
ENV OB_SYS_PASSWORD "pswd"

WORKDIR /root/boot/

RUN yum-config-manager --add-repo https://mirrors.aliyun.com/oceanbase/OceanBase.repo \
    && yum install -y oceanbase-ce-libs-${OB_LIB_VERSION} oceanbase-ce-utils-${OB_LIB_VERSION} oceanbase-ce-devel-${OB_LIB_VERSION} libaio* oblogproxy-${OB_LOG_PROXY_VERSION} \
    && rm -f /usr/local/oblogproxy/conf/conf.json && yum clean all

COPY boot /root/boot/
EXPOSE 2983
CMD /root/boot/boot.sh
