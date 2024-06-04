FROM mongo:6.0

ENV CRON_TIME="0 0 * * *" \
  TZ=UTC \
  CRON_TZ=UTC

# Install Python and Cron
RUN \
  apt-get update && \
  apt-get --assume-yes --no-install-recommends install \
    awscli \
    cron && \
  rm -rf \
   /var/lib/apt/lists/* \
   /tmp/* \
   /var/tmp/*

COPY run.sh /run.sh
RUN chmod +x /run.sh
CMD /run.sh