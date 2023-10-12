FROM centos:centos7

COPY boot /root/boot/
WORKDIR /root/boot/

RUN yum install -y yum-utils && \
    yum-config-manager --add-repo https://mirrors.aliyun.com/oceanbase/OceanBase.repo && \
    sed -i 's/$releasever/7/' /etc/yum.repos.d/OceanBase.repo && \
    yum install -y ob-deploy && \
    obd cluster deploy test -c config.yaml && \
    rm -rf /usr/obd/mirror/remote/* && \
    yum clean all

EXPOSE 8080
CMD /root/boot/boot.sh
