FROM runmymind/docker-android-sdk

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8

RUN apt-get update && apt-get install -y gcc build-essential dh-autoreconf
RUN apt-get update && apt-get install -y ruby ruby-dev
RUN gem install fastlane -NV
