FROM ruby:2.3.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs memcached
RUN mkdir /yogy
RUN /etc/init.d/memcached start
RUN rm -f /yogy/tmp/pids/server.pid
WORKDIR /yogy
ADD Gemfile /yogy/Gemfile
ADD Gemfile.lock /yogy/Gemfile.lock
RUN bundle install
ADD . /yogy
