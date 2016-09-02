FROM maven:3.3.3-jdk-8

RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y git npm && \
  apt-get clean all

RUN npm install -g bower grunt

RUN git clone https://github.com/apache/zeppelin.git /usr/local/zeppelin
WORKDIR /usr/local/zeppelin
RUN git checkout v0.6.1

RUN mvn clean package -Pspark-1.6 -Phadoop-2.6 -DskipTests

RUN rm -rf /var/lib/apt/lists/* && \
  apt-get update && \
  apt-get install -y gettext && \
  apt-get install -y sudo && \
  apt-get clean all

VOLUME /usr/local/spark

RUN rm -rf conf

COPY conf.templates conf.templates

VOLUME ["/usr/local/zeppelin/notebooks"]
VOLUME ["/usr/local/zeppelin/conf"]
VOLUME ["/hive"]

EXPOSE 8080

COPY start-zeppelin.sh bin

ENTRYPOINT ["bin/start-zeppelin.sh"]
