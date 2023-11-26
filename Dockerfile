# modified from https://github.com/chriscrowe/docker-pihole-unbound
ARG PIHOLE_VERSION
FROM pihole/pihole:${PIHOLE_VERSION:-latest}
RUN sudo apt update && sudo apt upgrade -y
RUN sudo apt install unbound -y
RUN sudo apt install wget -y

# optional packages
RUN sudo apt install nano -y
RUN sudo apt install systemctl -y

# unbound
COPY build-files/lighttpd-external.conf /etc/lighttpd/external.conf 
COPY build-files/pi-hole.conf /etc/unbound/unbound.conf.d/pi-hole.conf
COPY build-files/99-edns.conf /etc/dnsmasq.d/99-edns.conf
RUN mkdir -p /etc/services.d/unbound
COPY build-files/unbound-run /etc/services.d/unbound/run

# copy the rest of /home/
COPY home/ /home/
RUN chmod a+x /home/update-lists.sh
RUN /home/update-lists.sh
RUN crontab /home/mycrontab

ENTRYPOINT ./s6-init