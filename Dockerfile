FROM ruby:2.4.2
MAINTAINER leo@scalingo.com

ENV NODE_VERSION 6.9.2
ENV PATH "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/src/app/frontend/node_modules/.bin:/usr/src/app/vendor/.bundle/ruby/2.4.0/bin"

RUN cd /opt && \
    curl -L "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" | tar -xJf - && \
    mv -v node-v$NODE_VERSION-linux-x64 node && \
    apt-get update && apt-get install sudo && apt-get clean &&\
    sed -i s+secure_path=.*+secure_path="$PATH"+ /etc/sudoers

WORKDIR /usr/src/app

ENTRYPOINT ["/usr/src/app/bin/docker-entrypoint.sh"]
