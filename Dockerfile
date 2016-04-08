FROM frosner/docker-spark

MAINTAINER Frank Rosner <frank@fam-rosner.de>

RUN curl -s http://ftp.fau.de/apache/incubator/zeppelin/0.5.6-incubating/zeppelin-0.5.6-incubating-bin-all.tgz | tar -xz -C /usr/local \
  && mv /usr/local/zeppelin-0.5.6-incubating-bin-all /usr/local/zeppelin \
  && rm -rf /usr/local/zeppelin/notebook
ADD zeppelin-site.xml /usr/local/zeppelin/conf/zeppelin-site.xml
ADD zeppelin-env.sh /usr/local/zeppelin/conf/zeppelin-env.sh
ADD interpreter.json /usr/local/zeppelin/conf/interpreter.json

RUN mkdir /etc/service/zeppelin
ADD start-zeppelin.sh /etc/service/zeppelin/run
RUN chmod a+x /etc/service/zeppelin/run

CMD ["/sbin/my_init"]
