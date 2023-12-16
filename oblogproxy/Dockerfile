FROM centos:centos7

# docker build --build-arg VERSION={VERSION} .
ARG VERSION

ENV OB_SYS_USERNAME="root"
ENV OB_SYS_PASSWORD="password"

WORKDIR /root/boot/

RUN yum install -y yum-utils && \
    yum-config-manager --add-repo https://mirrors.aliyun.com/oceanbase/OceanBase.repo && \
    sed -i 's/$releasever/7/' /etc/yum.repos.d/OceanBase.repo && \
    yum clean all

RUN if [ -z "${VERSION}" ]; then \
      echo "VERSION is empty, then build the docker with latest rpm"; \
      V=`yum info oblogproxy | grep Version | awk '{print $3}'`; \
      R=`yum info oblogproxy | grep Release | awk '{print $3}' | awk -F. '{print $1}'`; \
      VERSION="${V}-${R}"; \
    else \
      echo "build the docker with VERSION ${VERSION}"; \
    fi && \
    yum install -y oblogproxy-${VERSION}.el7 && \
    rm -f /usr/local/oblogproxy/conf/conf.json

COPY boot /root/boot/
EXPOSE 2983
CMD /root/boot/boot.sh
