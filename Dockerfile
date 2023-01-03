FROM kalilinux/kali-rolling

RUN apt-get -y update && apt-get -y dist-upgrade && apt-get clean
RUN apt-get install -y gnupg
RUN apt install -y unzip
RUN apt install -y nano
RUN apt-get update && \
apt-get install --no-install-recommends -y \
ca-certificates \
expect \
openjdk-11-jdk \
curl && \
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* &&\
update-java-alternatives -s java-1.11.0-openjdk-amd64
RUN apt-get update && apt-get install -y iproute2

WORKDIR /opt
RUN mkdir /opt/cobaltstrike
RUN mkdir /opt/cs-docker-entrypoint
COPY ./docker-entrypoint.sh /opt/cs-docker-entrypoint/
RUN chmod +x /opt/cs-docker-entrypoint/docker-entrypoint.sh

WORKDIR /opt/cobaltstrike

EXPOSE 50050
ENTRYPOINT ["/opt/cs-docker-entrypoint/docker-entrypoint.sh"]

STOPSIGNAL SIGKILL
