FROM eclipse-temurin:8-jdk

RUN apt-get update && apt-get install -y --no-install-recommends \
  wget \
  default-mysql-client \
  vim-tiny \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir /hsj

WORKDIR /hsj

RUN wget https://www.handle.net/hnr-source/hsj-8.1.4.tar.gz -O hsj.tar.gz \
  && tar -xf hsj.tar.gz --strip-components=1 \
  && wget https://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.44/mysql-connector-java-5.1.44.jar \
      -O lib/mysql-connector-java-5.1.44-bin.jar

WORKDIR /hsj

COPY ./config/hdl-setup-server.txt .

RUN mkdir -p /ihs

RUN cat hdl-setup-server.txt | bin/hdl-setup-server /ihs

WORKDIR /ihs

COPY ./config/server_config.dct config.dct

RUN mkdir -p /root/.handle

RUN cp siteinfo.json /root/.handle/resolver_site

WORKDIR /root/.handle

COPY ./config/client_config.dct config.dct

RUN echo "*" > local_nas

WORKDIR /hsj

COPY ./config/create_tables.sql .
COPY ./config/insert_into.sql .
COPY ihs-server.sh .

ENTRYPOINT ["./ihs-server.sh"]
