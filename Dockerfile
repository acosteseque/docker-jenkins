FROM jenkins
MAINTAINER Anthony Costeseque <anthony.costeseque@axians.com>

# Suppress apt installation warnings
ENV DEBIAN_FRONTEND=noninteractive

# Change to root user
USER root

# Install base packages
RUN apt-get update -y && \
    apt-get install ruby apt-transport-https curl python-dev python-setuptools libffi-dev libssl-dev gcc make -y && \
    easy_install pip

# Install Docker Engine
RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
    echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | tee /etc/apt/sources.list.d/docker.list && \
    apt-get update -y && \
    apt-get purge lxc-docker* -y && \
    apt-get install docker-engine -y && \
    usermod -aG docker jenkins && \
    usermod -aG users jenkins

# Install Docker Compose
RUN pip install pip --upgrade && \
    pip install docker-compose --upgrade && \
    pip install ansible boto boto3 --upgrade

# Change to jenkins user
USER jenkins

# Add Jenkins plugins
COPY plugins.txt /usr/share/jenkins/ref/
# COPY custom.groovy /usr/share/jenkins/ref/init.groovy.d/custom.groovy
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/ref/plugins.txt
