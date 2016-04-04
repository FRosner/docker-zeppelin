FROM frosner/docker-spark

MAINTAINER Frank Rosner <frank@fam-rosner.de>

RUN curl -s http://ftp.fau.de/apache/incubator/zeppelin/0.5.6-incubating/zeppelin-0.5.6-incubating-bin-all.tgz | tar -xz -C /usr/local \
  && mv /usr/local/zeppelin-0.5.6-incubating-bin-all /usr/local/zeppelin
