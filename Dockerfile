ARG RUBY_VERSION=2.7.2
FROM ruby:${RUBY_VERSION}
ARG BUNDLER_VERSION=2.2.25
ARG UNAME=spec
ARG UID=1000
ARG GID=1000

LABEL maintainer="dla-staff@umich.edu"

# Install Vim
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  vim-tiny

RUN gem install bundler:${BUNDLER_VERSION}

RUN groupadd -g ${GID} -o ${UNAME}
RUN useradd -m -d /app -u ${UID} -g ${GID} -o -s /bin/bash ${UNAME}
RUN mkdir -p /gems && chown ${UID}:${GID} /gems

USER $UNAME
COPY --chown=${UID}:${GID} Gemfile* *.gemspec /app/

ENV BUNDLE_PATH /gems

WORKDIR /app
RUN bundle _${BUNDLER_VERSION}_ install

COPY --chown=${UID}:${GID} . /app

CMD ["tail", "-f", "/dev/null"]