FROM maven:3.3.3-jdk-8

RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y git npm && \
  apt-get clean all

RUN npm install -g bower grunt

RUN git clone https://github.com/apache/zeppelin.git /usr/local/zeppelin
WORKDIR /usr/local/zeppelin
RUN git checkout master

RUN mvn clean package -Pspark-1.6 -Phadoop-2.6

ENTRYPOINT ["bin/zeppelin.sh"]
