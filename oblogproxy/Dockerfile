FROM centos:centos7

ARG PKG_NAME="oblogproxy-ce-for-4x-1.1.3-20230815201457.tar.gz"
ARG DOWNLOAD_URL="https://github.com/oceanbase/oblogproxy/releases/download/v1.1.3/oblogproxy-ce-for-4x-1.1.3-20230815201457.tar.gz"

ENV OB_SYS_USERNAME="root"
ENV OB_SYS_PASSWORD="password"

WORKDIR /root/boot/

RUN yum install -y wget iproute &&  \
    wget $DOWNLOAD_URL && tar -zxvf $PKG_NAME -C /usr/local && rm -rf $PKG_NAME && \
    rm -f /usr/local/oblogproxy/conf/conf.json

COPY boot /root/boot/
EXPOSE 2983
CMD /root/boot/boot.sh
