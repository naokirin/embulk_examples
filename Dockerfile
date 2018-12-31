FROM openjdk:8-alpine

ENV EMBULK_VERSION 0.9.12
RUN apk --update add --virtual build-dependencies curl \
    && curl -o  /embulk/embulk --create-dirs -L "https://dl.bintray.com/embulk/maven/embulk-${EMBULK_VERSION}.jar" \
    && chmod +x /embulk/embulk \
    && apk del build-dependencies
RUN apk --update --no-cache add \
      libc6-compat make gcc g++ libc-dev libstdc++ \
      ruby ruby-dev ruby-rake ruby-bundler ruby-json \
    && rm /var/cache/apk/*

RUN mkdir /workdir
WORKDIR /workdir
COPY Gemfile /workdir/Gemfile
RUN /embulk/embulk bundle
COPY config /workdir/config

