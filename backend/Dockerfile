FROM pdubois/docker-alfresco:master
<<<<<<< HEAD
# FROM alfrescobase
=======
>>>>>>> 618f7cb9ad23ef50ed5cd5dc361c1eb67d171028

MAINTAINER Philippe Dubois <philippe.dubois@alfresco.com>


RUN apt-get update
RUN apt-get install -y software-properties-common curl
RUN apt-add-repository -y ppa:webupd8team/java
RUN apt-get update
RUN echo debconf shared/accepted-oracle-license-v1-1 select true |  debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
RUN apt-get install -y oracle-java8-set-default libgtk2.0-0 libxtst6
RUN apt-get --purge autoremove -y software-properties-common curl
RUN apt-get clean


RUN   apt-get -y install curl libc6 libcurl3 zlib1g
RUN   apt-get -y install vim
RUN   apt-get -y install iputils-ping && apt-get -y install -y net-tools


RUN   apt-get -y install unzip
RUN   apt-get update
RUN   apt-get -y install firefox
RUN   apt-get install -y chromium-browser



RUN apt-get -y install git

RUN cd ~ && wget http://download.eclipse.org/technology/epp/downloads/release/mars/1/eclipse-java-mars-1-linux-gtk-x86_64.tar.gz \
    && tar xvf eclipse-java-mars-1-linux-gtk-x86_64.tar.gz

RUN apt-cache search maven && apt-get install -y maven

# Enabling CORS
RUN wget https://artifacts.alfresco.com/nexus/service/local/repositories/releases/content/org/alfresco/enablecors/1.0/enablecors-1.0.jar

COPY prefs.epf .

# Enable CORS
RUN mv enablecors-1.0.jar /opt/alfresco/modules/platform


# Install API Explorer
RUN wget https://artifacts.alfresco.com/nexus/service/local/repositories/releases/content/org/alfresco/api-explorer/1.4/api-explorer-1.4.war && \
    mv api-explorer-1.4.war /opt/alfresco/tomcat/webapps/api-explorer.war


RUN ls -la /opt/alfresco/amps/



EXPOSE 8443
EXPOSE 8080

ENTRYPOINT ./entry.sh


