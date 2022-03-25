FROM mariadb:10.6.7-focal

# Install Vim
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  vim-tiny

COPY conf.d /etc/mysql/conf.d
COPY docker-entrypoint-initdb.d /docker-entrypoint-initdb.d
COPY ihs /ihs
