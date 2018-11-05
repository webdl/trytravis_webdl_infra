#!/bin/bash
set -e

APP_DIR=$HOME/reddit

# Clone Reddit app and install requirements
git clone -b monolith https://github.com/express42/reddit.git $APP_DIR
cd $APP_DIR
bundle install

# Start Puma as service
echo DATABASE_URL=$1 >> $APP_DIR/.env
sudo mv /tmp/puma.service /etc/systemd/system/puma.service
sudo systemctl start puma
sudo systemctl enable puma
