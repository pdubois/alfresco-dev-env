FROM ubuntu:trusty

MAINTAINER Philippe Dubois <philippe.dubois@alfresco.com>

# Declare constants
ENV NVM_VERSION v0.31.0
ENV NODE_VERSION v7.1.0

RUN apt-get update
RUN apt-get install -y wget
RUN apt-get update
RUN apt-get -y install build-essential libssl-dev
RUN apt-get -y install curl libc6 libcurl3 zlib1g
RUN apt-get -y install iputils-ping && apt-get -y install -y net-tools
RUN apt-get -y install nano
RUN apt-get -y install firefox
RUN apt-get -y --force-yes install apt-transport-https
RUN echo  "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
RUN apt-get update 
RUN apt-get -y --force-yes install google-chrome-stable

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh


# Install pre-reqs
RUN apt-get update
RUN apt-get -y install curl build-essential

# Install tree command
RUN apt-get update
RUN apt-get install tree

RUN adduser --disabled-password --quiet --gecos '' npm
USER npm



# Install NVM
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/${NVM_VERSION}/install.sh | bash

# Install NODE
RUN source ~/.nvm/nvm.sh; \
    nvm install $NODE_VERSION; \
    nvm use --delete-prefix $NODE_VERSION; \
    npm install -g yo; \
    npm install -g generator-ng2-alfresco-app; \
    npm install -g angular-cli;
    
RUN cd ~ && wget --no-check-certificate https://download.jetbrains.com/webstorm/WebStorm-2016.3.3.tar.gz \
    && tar xfz WebStorm-2016.3.3.tar.gz && rm WebStorm-2016.3.3.tar.gz

# Define "webstorm" as alias on /home/npm/WebStorm-162.1628.41/bin/webstorm.sh
RUN echo "alias webstorm='/home/npm/WebStorm-163.12024.17/bin/webstorm.sh'" >>~/.bashrc

# Create a folder where some folder from the host will be mounted
# i.e.: -v <path to host dir>:/home/npm/projects
RUN mkdir ~/projects
   

ENTRYPOINT /bin/bash

