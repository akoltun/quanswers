#!/bin/bash

cd ~
# server update & setup
sudo apt-get update -y
sudo apt-get upgrade -y
sudo echo "Europe/Moscow" > timezone 
sudo mv timezone /etc/timezone 
sudo dpkg-reconfigure -f noninteractive tzdata
sudo apt-get install mc -y
echo "SELECTED_EDITOR=\"/usr/bin/mcedit\"" > ~/.selected_editor
sudo apt-get install curl -y

# install ruby
\curl -sSL https://rvm.io/mpapis.asc | gpg --import -
# \curl -sSL https://get.rvm.io | bash -s stable --ruby
\curl -sSL https://get.rvm.io | bash -s stable
source /home/sasha/.rvm/scripts/rvm
rvm requirements
command rvm install 2.1.5
# rvm use default
rvm use 2.1.5 --default

# install libmysql - dependence for gem mysql2
sudo apt-get install libmysqlclient-dev -y

# install postgresql
sudo apt-get install postgresql postgresql-contrib postgresql-server-dev-9.3 -y
sudo sudo -u postgres createuser sasha
sudo sudo -u postgres createdb -O sasha quanswers 

# install git
sudo apt-get install git-core -y

# install passenger
gem install passenger
sudo apt-get install libcurl4-openssl-dev -y
rvmsudo passenger-install-nginx-module --auto --languages ruby

# install redis for sidekiq
sudo apt-get install redis-server -y
sudo cp /etc/redis/redis.conf /etc/redis/redis.conf.default

# install sphinx
sudo apt-get install sphinxsearch -y

# install mail server
sudo apt-get install exim4-daemon-light mailutils -y

# install monit
sudo apt-get install monit -y

# install backup
gem install backup
backup generate:model -t quanswers_backup --databases='postgresql' --storages='local' --compressor='gzip'

# install whenever
gem install whenever

# create place for config
mkdir /home/sasha/quanswers
mkdir /home/sasha/quanswers/shared
mkdir /home/sasha/quanswers/shared/config
mkdir /home/sasha/Backup/config

# set default environment as staging
printf "\nexport RAILS_ENV=staging" >> ~/.bash_profile

