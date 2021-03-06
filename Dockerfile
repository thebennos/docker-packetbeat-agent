FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN locale-gen en_US en_US.UTF-8
ENV LANG en_US.UTF-8
RUN echo "export PS1='\e[1;31m\]\u@\h:\w\\$\[\e[0m\] '" >> /root/.bashrc

#Runit
RUN apt-get install -y runit
CMD export > /etc/envvars && /usr/sbin/runsvdir-start
RUN echo 'export > /etc/envvars' >> /root/.bashrc

#Utilities
RUN apt-get install -y vim less net-tools inetutils-ping wget curl git telnet nmap socat dnsutils netcat tree htop unzip sudo software-properties-common jq psmisc

RUN apt-get -y -q install libpcap0.8

RUN wget https://github.com/packetbeat/packetbeat/releases/download/v0.5.0/packetbeat_0.5.0-1_amd64.deb && \
    dpkg -i packetbeat*.deb && \
    rm packetbeat*.deb

ADD packetbeat.conf /etc/packetbeat/packetbeat.conf

#Add runit services
ADD sv /etc/service 
