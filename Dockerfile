FROM openjdk:8-alpine
LABEL maintainer="Reaction Commerce <engineering@reactioncommerce.com>"

RUN apk update && apk upgrade \
 && apk --update add curl openssl \
 && rm -rf /tmp/* /var/cache/apk/*

ENV DOCKERIZE_VERSION v0.6.1
RUN set -o pipefail \
 && curl -Ls https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    | tar xzv -C /usr/local/bin

ENV JMX_EXPORTER_VERSION 0.11.0
ENV JMX_EXPORTER_PATH=/opt/jmx_exporter
ENV JMX_EXPORTER_JAR_NAME jmx_prometheus_httpserver-$JMX_EXPORTER_VERSION-jar-with-dependencies.jar
ENV JMX_EXPORTER_JAR "$JMX_EXPORTER_PATH/$JMX_EXPORTER_JAR_NAME"
ENV CONFIG_DIR="$JMX_EXPORTER_PATH/config"
ENV CONFIG_FILE="$CONFIG_DIR/config.yaml"
ENV CONFIG_TEMPLATE="$CONFIG_DIR/config.yaml.template"

RUN mkdir -p "$JMX_EXPORTER_PATH/config"

RUN curl -L https://github.com/Yelp/dumb-init/releases/download/v1.2.1/dumb-init_1.2.1_amd64 -o usr/local/bin/dumb-init && chmod +x /usr/local/bin/dumb-init
RUN curl -L https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_httpserver/$JMX_EXPORTER_VERSION/$JMX_EXPORTER_JAR_NAME -o "$JMX_EXPORTER_JAR"

COPY config.yaml.template /opt/jmx_exporter/config/
COPY start.sh /opt/jmx_exporter/

# Application ENV defaults
ENV SERVICE_PORT=5556
ENV START_DELAY_SECONDS=0
ENV JMX_HOST_PORT=localhost:9010
ENV JMX_USERNAME=""
ENV JMX_PASSWORD=""
ENV JMX_SSL=false
ENV JMX_LOCAL_PORT=5555
ENV LOWERCASE_OUTPUT_NAME=false
ENV LOWERCASE_OUTPUT_LABEL_NAMES=false
ENV JVM_LOCAL_OPTS="-Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.port=$JMX_LOCAL_PORT"

# 5555 - Local JMX
# 5556 - Prometheus Metrics Server
EXPOSE 5555 5556

CMD ["usr/local/bin/dumb-init", "/opt/jmx_exporter/start.sh"]
