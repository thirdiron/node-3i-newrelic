#!/bin/bash

# Felix should have left us an SSH key retrieved from heroku
# fail loudly if that's not present since any Third Iron private dependencies
# will fail to install.

[ ! \( -f /vagrant/dev/keyFileName.txt \) ] && echo "SSH Key File Name File Missing!" && exit 1;  # Where is the file that tells us the location of our tmp file with the key?
keyFile=/vagrant/`cat /vagrant/dev/keyFileName.txt`
[ ! \( -f $keyFile \) ] && echo "SSH Key Missing!" && exit 1;

cp $keyFile /home/vagrant/.ssh/id_rsa
chown vagrant:vagrant /home/vagrant/.ssh/id_rsa
chmod 600 /home/vagrant/.ssh/id_rsa

# Add github to the vagrant user's list of known hosts
su -c "ssh -oStrictHostKeyChecking=no -T git@github.com || true;"  vagrant

apt-get update
apt-get install python-software-properties -y # contains apt-add-repository command
apt-get update

# need libpq-dev as the postgresql client library npm module says it needs this
apt-get -y install build-essential
apt-get -y install curl
#apt-get -y install redis-server
apt-get -y install make # need make for building npm modules
apt-get -y install g++ # ditto for g++

# need git for npm to fetch modules straight from git repos
apt-get install -y git

apt-get install -y vim

#install node
apt-get -y purge nodejs*
curl -sL https://deb.nodesource.com/setup_8.x | sudo bash -
apt-get install -y nodejs

# Install heroku toolbelt
wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh

#use the bash_profile to set environment variables
ln -sf /vagrant/dev/bash_profile /home/vagrant/.bash_profile

# source bash_profile here so that npm install has same environment
# as it would have inside the VM (important for libxml)

. /vagrant/dev/bash_profile

# Now install the app's dependencies
cd /vagrant
rm -rf node_modules
rm -rf ~/.npm

