FROM openjdk:8u141-jdk

RUN apt-get update && apt-get install -y --no-install-recommends wget \
	&& rm -rf /var/lib/apt/lists/* \
  && mkdir /hsj

WORKDIR /hsj

RUN wget http://www.handle.net/hnr-source/hsj-8.1.4.tar.gz -O hsj.tar.gz \
  && tar -xf hsj.tar.gz --strip-components=1 \
  && wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.44.tar.gz \
  && tar -xf mysql-connector-java-5.1.44.tar.gz -C lib --strip-components=1 \
      mysql-connector-java-5.1.44/mysql-connector-java-5.1.44-bin.jar \
  && rm mysql-connector-java-5.1.44.tar.gz

# Install Vim
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
vim-tiny

WORKDIR /hsj