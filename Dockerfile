FROM ruby:2.6.5

ENV LANG C.UTF-8

WORKDIR /usr/src/app

COPY Gemfile ./
RUN gem update bundler
RUN bundle install

COPY . .
