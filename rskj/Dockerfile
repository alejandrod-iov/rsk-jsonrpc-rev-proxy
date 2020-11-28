#
# RSK Node Dockerfile
#

FROM ubuntu:18.04

ENV BRANCH="master"
ENV CODENAME="SNAPSHOT"
ENV VERSION="2.2.0"

RUN apt-get update -y && \
    apt-get install -y git curl gnupg openjdk-11-jdk && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove -y && \
    apt-get clean

RUN gpg --keyserver https://secchannel.rsk.co/release.asc --recv-keys 1A92D8942171AFA951A857365DECF4415E3B8FA4
RUN gpg --finger 1A92D8942171AFA951A857365DECF4415E3B8FA4

RUN git clone --single-branch --depth 1 --branch ${BRANCH} https://github.com/rsksmart/rskj.git /code/rskj

WORKDIR /code/rskj

RUN gpg --verify SHA256SUMS.asc
RUN sha256sum --check SHA256SUMS.asc
RUN ./configure.sh
RUN ./gradlew --no-daemon clean build -x test

COPY node.conf /etc/rsk/node.conf
COPY logback.xml /etc/rsk/logback.xml


EXPOSE 4444
EXPOSE 50505

ENTRYPOINT [ "java", \
    "-Xss4M", "-Xms2G", "-Xmx4G", \
    "-Drsk.conf.file=/etc/rsk/node.conf", \
    "-Dcom.sun.management.jmxremote", \
    "-Dcom.sun.management.jmxremote.port=3333", \
    "-Dcom.sun.management.jmxremote.ssl=false", \
    "-Dcom.sun.management.jmxremote.authenticate=false", \
    "-cp", "/code/rskj/rskj-core/build/libs/rskj-core-2.2.0-PAPYRUS-all.jar", \
    "co.rsk.Start" ]