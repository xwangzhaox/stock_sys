FROM ruby:3.0.0-alpine

RUN apk update && apk upgrade && apk add ruby ruby-json ruby-io-console ruby-bundler ruby-irb ruby-bigdecimal tzdata && apk add nodejs npm yarn && apk add curl-dev ruby-dev build-base libffi-dev && apk add build-base libxslt-dev libxml2-dev ruby-rdoc mysql-dev sqlite-dev imagemagick ghostscript-fonts ghostscript gcompat zip curl

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
COPY . .

ENV RAILS_ENV test

RUN gem uninstall nokogiri
RUN gem install nokogiri --platform=ruby
RUN bundle config set --local without 'development'
RUN bundle install

EXPOSE 3000

