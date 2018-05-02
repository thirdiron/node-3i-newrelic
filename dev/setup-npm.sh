#!/bin/bash

# DONT RUN AS ROOT IT SETS UP PERMISSIONS WRONG

# Setup npm global module installs to go under /home/vagrant/.npm-global
mkdir /home/vagrant/.npm-global
npm config set prefix '/home/vagrant/.npm-global'

npm -g install node-inspector   # node debugging
# PREPL!  A NodeJS REPL customized to work with promises
npm -g install "https://github.com/thirdiron/promise-repl.git"



