####
## NOTE:
##
## This Dockerfile is responsible of generating an application image with all the dependencies already installed.
## The `docker-compose` file will only run the image generated by this Dockerfile, connecting
## the other necessary tools (databases).
####
FROM ruby:3.1.4

# install necessary javascript runtime libs
RUN apt-get update -qq && apt-get install build-essential nodejs tzdata -y
RUN mkdir /app
WORKDIR /app
ADD . /app

# installing dependencies
COPY Gemfile ./Gemfile
COPY Gemfile.lock ./Gemfile.lock

RUN bundle install

## Add the wait script to the image
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.7.3/wait /usr/bin/wait
RUN chmod +x /usr/bin/wait

# add a script to be executed every time the container starts
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh