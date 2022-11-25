FROM alpine:3

# install packages
RUN apk --no-cache --no-progress add avahi avahi-tools tini

# remove default services
RUN rm /etc/avahi/services/*

# disable d-bus && ipv6 publish
RUN sed -i 's/.*enable-dbus=.*/enable-dbus=no/' /etc/avahi/avahi-daemon.conf \
  && sed -i 's/.*enable-reflector=.*/enable-reflector=yes/' /etc/avahi/avahi-daemon.conf \
  && sed -i 's/.*use-ipv6=.*/enable-reflector=no/' /etc/avahi/avahi-daemon.conf \
  && sed -i 's/.*publish-aaaa-on-ipv4=.*/publish-aaaa-on-ipv4=no/' /etc/avahi/avahi-daemon.conf \
  && sed -i 's/.*publish-a-on-ipv6=.*/publish-a-on-ipv6=no/' /etc/avahi/avahi-daemon.conf 
  
#display avahi-daemo.conf content
RUN cat /etc/avahi/avahi-daemon.conf


COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/sbin/tini", "--", "/docker-entrypoint.sh"]

# default command
CMD ["avahi-daemon"]

# volumes
VOLUME ["/etc/avahi/services"]
