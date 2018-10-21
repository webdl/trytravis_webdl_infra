#!/bin/bash
# Installing MongoDB, Ruby
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'

apt update
apt install -y mongodb-org ruby-full ruby-bundler build-essential

# Starting MondoDB as a service
systemctl start mongod.service
systemctl enable mongod.service

# Cloning and startup the App
git clone -b monolith https://github.com/express42/reddit.git
cd reddit
bundle install
puma -d

