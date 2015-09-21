FROM ubuntu:14.04
MAINTAINER Victor Lowther <victor@rackn.com>

ENV GOPATH /go

RUN apt-get update && apt-get install -y curl unzip \
  && mkdir -p /tmp/consul /ui \
  && curl -fL -o consul.zip https://dl.bintray.com/mitchellh/consul/0.5.2_linux_amd64.zip \
  && curl -fL -o consul_ui.zip https://dl.bintray.com/mitchellh/consul/0.5.2_web_ui.zip \
  && unzip consul.zip -d /usr/local/bin \
  && unzip consul_ui.zip -d /ui \
  && rm consul.zip consul_ui.zip \
  && mkdir -p /etc/consul.d \
  $$ mkdir -p /usr/local/sbin/
  && apt-get purge -y unzip \
  && curl -fgL -o '/tmp/goball.tgz' 'https://storage.googleapis.com/golang/go1.5.1.linux-amd64.tar.gz' \
  && rm -rf /usr/local/go \
  && tar -C '/usr/local' -zxf /tmp/goball.tgz \
  && rm /tmp/goball.tgz \
  && curl -fgL -o '/tmp/chef.deb' 'https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/10.04/x86_64/chef_11.18.12-1_amd64.deb' \
  && dpkg -i /tmp/chef.deb \
  && rm -f /tmp/chef.deb \

COPY docker-entrypoint.sh /sbin/docker-entrypoint.sh

# Set our command
ENTRYPOINT ["/sbin/docker-entrypoint.sh"] 
