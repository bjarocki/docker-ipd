FROM golang:alpine

ENV INDEX_URL https://raw.githubusercontent.com/martinp/ipd/master/index.html
ENV GEOIP_COUNTRY_URL http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.mmdb.gz
ENV GEOIP_CITY_URL http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz

RUN go get github.com/mpolden/ipd/...
RUN \
  cd /tmp && \
  curl -SsLO $GEOIP_COUNTRY_URL && \
  curl -SsLO $GEOIP_CITY_URL && \
  curl -SsLO $INDEX_URL && \
  gunzip *.gz

ENTRYPOINT ["ipd", "-H", "X-Real-IP", "-f", "/tmp/GeoLite2-Country.mmdb", "-c", "/tmp/GeoLite2-City.mmdb", "-t", "/tmp/index.html"]
