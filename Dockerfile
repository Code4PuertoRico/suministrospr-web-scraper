FROM ruby:2.6.5

ENV LANG C.UTF-8

WORKDIR /usr/src/app

COPY Gemfile ./
RUN bundle install

COPY . .
