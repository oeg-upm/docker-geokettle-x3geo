# Declare base image, because the plugins need to
# be compatible with Jena, Jena has Java 8 as base
# so we need Java 8, OpenJDK for this Docker Image.

FROM buildpack-deps:jessie-scm
MAINTAINER Alejandro F. Carrera

# Set environment
ENV LANGUAGE=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    JAVA_HOME=/docker-java-home \
    GEOKETTLE_VERSION=2.5 \
    GEOKETTLE_SVN=http://dev.spatialytics.com/svn/geokettle-2.0/trunk \
    GEOKETTLE_PATH=/opt/geokettle \
    XGEO_GIT=https://github.com/oeg-upm/geo.linkeddata.es-TripleGeoKettle \
    ANT_URL=http://ftp.cixug.es/apache/ant/binaries/ \
    ANT_PATH=apache-ant-1.10.1 \
    ANT_HOME=/usr/local/ant \
    PATH="${PATH}:/usr/local/ant/bin:/opt/geokettle"

# Install Java 8
RUN apt-get update && \
    apt-get install -y --no-install-recommends bzip2 unzip xz-utils && \
    echo 'deb http://deb.debian.org/debian jessie-backports main' > /etc/apt/sources.list.d/jessie-backports.list && \
    { \
        echo '#!/bin/sh'; \
        echo 'set -e'; \
        echo; \
        echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
    } > /usr/local/bin/docker-java-home && \
    chmod +x /usr/local/bin/docker-java-home && \
    ln -svT "/usr/lib/jvm/java-8-openjdk-$(dpkg --print-architecture)" /docker-java-home && \
    apt-get update && \
    apt-get install -y openjdk-8-jdk=8u131-b11-1~bpo8+1 ca-certificates-java=20161107~bpo8+1 && \
    [ "$(readlink -f "$JAVA_HOME")" = "$(docker-java-home)" ] && \
    update-alternatives --get-selections | awk -v home="$(readlink -f "$JAVA_HOME")" 'index($3, home) == 1 { $2 = "manual"; print | "update-alternatives --set-selections" }' && \
    update-alternatives --query java | grep -q 'Status: manual' && \
    /var/lib/dpkg/info/ca-certificates-java.postinst configure

# Download GeoKettle and Apache Ant
RUN cd /opt && \
    svn checkout $GEOKETTLE_SVN $GEOKETTLE_PATH && \
    curl $ANT_URL/$ANT_PATH-bin.zip -o $ANT_PATH.zip && \
    unzip $ANT_PATH.zip && \
    rm -rf $ANT_PATH.zip && \
    mv $ANT_PATH /usr/local/ant

# Compile Geokettle
RUN cd $GEOKETTLE_PATH && \
    ant && \
    mv distrib /tmp/geokettle && \
    rm -rf $GEOKETTLE_PATH && \
    mv /tmp/geokettle $GEOKETTLE_PATH

# Install TripleGeoKettle plugin
RUN cd /opt && \
    git clone $XGEO_GIT triplegeo && \
    cd triplegeo/build && \
    ant && \
    mv ../dist /opt/geokettle/plugins/steps/tripleGeoplugin

# Clean docker image
RUN apt-get clean -y && \
  apt-get autoclean -y && \
  apt-get autoremove -y && \
  rm -rf /opt/triplegeo && \
  rm -rf /tmp/* && \
  rm -rf /usr/share/locale/* && \
  rm -rf /var/cache/debconf/*-old && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /usr/share/doc/*

# Default terminal
WORKDIR $GEOKETTLE_PATH
ENTRYPOINT ["/bin/bash"]

