FROM openjdk:8-alpine

ENV EMBULK_VERSION 0.9.12
ENV DIGDAG_VERSION 0.9.31
RUN apk --update add --virtual build-dependencies curl \
    && curl -o /embulk/embulk --create-dirs -L "https://dl.bintray.com/embulk/maven/embulk-${EMBULK_VERSION}.jar" \
    && chmod +x /embulk/embulk \
    && curl -o /digdag/digdag --create-dirs -L "https://dl.digdag.io/digdag-${DIGDAG_VERSION}" \
    && chmod +x /digdag/digdag \
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
COPY schedule.dig /workdir/schedule.dig

