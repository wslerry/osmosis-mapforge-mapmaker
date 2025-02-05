FROM eclipse-temurin:17.0.7_7-jdk

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ="Asia/Kuching"
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

ARG OSMOSIS_VERSION='0.49.2'
ENV OSMOSIS_VERSION=$OSMOSIS_VERSION

# Set the working directory
WORKDIR /opt/osmosis

# Install additional packages using apt
RUN set -eux \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        figlet \
        tzdata \
        locales \
        tini \
    && echo $TZ > /etc/timezone \
    && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && sed -i "s/# $LANG UTF-8/$LANG UTF-8/" /etc/locale.gen \
    && locale-gen $LANG && update-locale LANG=$LANG \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/apt/lists/* \
    && curl -SL https://github.com/openstreetmap/osmosis/releases/download/${OSMOSIS_VERSION}/osmosis-${OSMOSIS_VERSION}.tar -o /opt/osmosis.tar \
    && tar -xvf /opt/osmosis.tar -C /opt/osmosis --strip-components=1 \
    && rm /opt/osmosis.tar \
    && chmod 0755 /opt/osmosis/bin/osmosis \
    && ln -s /opt/osmosis/bin/osmosis /usr/local/bin/osmosis \
    && mkdir -p /data/input /data/output /opt/osmosis/plugins/ \
    && curl -SL https://repo1.maven.org/maven2/org/mapsforge/mapsforge-map-writer/0.20.0/mapsforge-map-writer-0.20.0-jar-with-dependencies.jar \
        -o /opt/osmosis/plugins/mapsforge-map-writer-0.20.0-jar-with-dependencies.jar \
    && curl -SL https://repo1.maven.org/maven2/org/mapsforge/mapsforge-poi-writer/0.20.0/mapsforge-poi-writer-0.20.0-jar-with-dependencies.jar \
        -o /opt/osmosis/plugins/mapsforge-poi-writer-0.20.0-jar-with-dependencies.jar

COPY entrypoint.sh /opt/osmosis/entrypoint.sh
RUN set -eux; \
    chmod +x entrypoint.sh; \
    sed -i "s/\r$//" entrypoint.sh;

WORKDIR /opt/osmosis

ENTRYPOINT ["tini", "--"]

CMD [ "/opt/osmosis/entrypoint.sh" ]