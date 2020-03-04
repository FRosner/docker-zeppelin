FROM openjdk:8-jre

RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y \
    curl \
    grep \
    sed \
    git \
    wget \
    bzip2 \
    gettext \
    sudo \
    ca-certificates \
    libglib2.0-0 \
    libxext6 \
    libsm6 \
    libxrender1 \
    libaio1 \
    build-essential \
    p7zip \
    unzip && \
  apt-get clean all

# INSTALL ORACLE INSTANT CLIENT
RUN mkdir -p opt/oracle
ADD ./oracle/linux/ .
RUN unzip instantclient-basic-linux.x64.zip -d /opt/oracle \
 && unzip instantclient-sdk-linux.x64.zip -d /opt/oracle  \
 && unzip instantclient-sqlplus-linux.x64.zip -d /opt/oracle \
 && mv /opt/oracle/instantclient_* /opt/oracle/instantclient \
 && ln -s /opt/oracle/instantclient/libclntsh.so.* /opt/oracle/instantclient/libclntsh.so \
 && ln -s /opt/oracle/instantclient/libocci.so.* /opt/oracle/instantclient/libocci.so
RUN mkdir -p opt/oracle/instantclient/network/admin

ENV OCI_HOME="/opt/oracle/instantclient"
ENV OCI_LIB_DIR="/opt/oracle/instantclient"
ENV OCI_INCLUDE_DIR="/opt/oracle/instantclient/sdk/include"
ENV OCI_VERSION=12
ENV LD_LIBRARY_PATH="/opt/oracle/instantclient"
ENV TNS_ADMIN="/opt/oracle/instantclient"
ENV ORACLE_BASE="/opt/oracle/instantclient"
ENV ORACLE_HOME="/opt/oracle/instantclient"
ENV PATH="/opt/oracle/instantclient:$PATH"
RUN echo '/opt/oracle/instantclient/' | tee -a /etc/ld.so.conf.d/oracle_instant_client.conf && ldconfig


RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
  wget --quiet https://repo.continuum.io/archive/Anaconda2-4.2.0-Linux-x86_64.sh -O ~/anaconda.sh && \
  /bin/bash ~/anaconda.sh -b -p /opt/conda && \
  rm ~/anaconda.sh

RUN /opt/conda/bin/conda install SQLAlchemy psycopg2 pymssql cx_Oracle
RUN ln -s /opt/conda/bin/python /usr/bin/python

ADD spark /usr/local/spark

ADD zeppelin /usr/local/zeppelin
WORKDIR /usr/local/zeppelin

RUN rm -rf conf

COPY conf.templates conf.templates

VOLUME ["/usr/local/zeppelin/notebooks"]
VOLUME ["/usr/local/zeppelin/conf"]
VOLUME ["/hive"]

EXPOSE 8080

COPY start-zeppelin.sh bin

ENTRYPOINT ["bin/start-zeppelin.sh"]
