Docker JMX exporter for Prometheus
==================================

A dockerized JMX Exporter image. It uses alpine-java and dumb-init to provide a
relatively small image (approx 130Mb) and includes a released version of
jmx_exporter from the [maven central
repository](https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_httpserver/)

Source code available at [reactioncommerce/docker-jmx-prometheus-exporter](https://github.com/reactioncommerce/jmx-prometheus-exporter/)
and the images is on [Docker hub](https://hub.docker.com/r/reactioncommerce/jmx-prometheus-exporter/).

This is a fork of [sscaling/docker-jmx-prometheus-exporter](https://github.com/sscaling/jmx-prometheus-exporter/)
which is available on [Docker hub](https://hub.docker.com/r/sscaling/jmx-prometheus-exporter/).

Building docker image
---------------------

```
docker build -t reactioncommerce/jmx-prometheus-exporter .
```

Running
-------

```
docker run --rm -p "5556:5556" reactioncommerce/jmx-prometheus-exporter
```

Then you can visit the metrics endpoint: [http://127.0.0.1:5556/metrics](http://127.0.0.1:5556/metrics) (assuming docker is running on localhost)

Configuration
-------------

By default, the jmx-exporter is configured to monitor it's own metrics (as per the main repo example). However, to provide your own configuration, mount the YAML file as a volume

```
docker run --rm -p "5556:5556" -v "$PWD/config.yml:/opt/jmx_exporter/config.yml" reactioncommerce/jmx-prometheus-exporter
```

The configuration options are documented: [https://github.com/prometheus/jmx_exporter](https://github.com/prometheus/jmx_exporter)

### Environment variables

Additionally, the following environment variables can be defined

Name     | Description
---------|------------
`SERVICE_PORT` | Port to run the JMX exporter. Prometheus will scrape `/metrics` on this port. Default: 5556
`JMX_LOCAL_OPTIONS` | The JVM options for the prometheus exporter process.
`START_DELAY_SECONDS` | Start delay before serving requests. Any requests within the delay period will result in an empty metrics set. Default: 0
`JMX_HOST_PORT` | The host and port to connect to via remote JMX. If neither this nor `JMX_URL` is specified, will talk to the local JVM.
`JMX_USERNAME` | The username to be used in remote JMX password authentication.
`JMX_PASSWORD` | The password to be used in remote JMX password authentication.
`JMX_SSL`      | Whether JMX connection should be done over SSL. To configure certificates you have to set following system properties:<br/>`-Djavax.net.ssl.keyStore=/home/user/.keystore`<br/>`-Djavax.net.ssl.keyStorePassword=changeit`<br/>`-Djavax.net.ssl.trustStore=/home/user/.truststore`<br/>`-Djavax.net.ssl.trustStorePassword=changeit`
`LOWERCASE_OUTPUT_NAME` | Lowercase the output metric name. Applies to default format and `name`. Defaults to false.
`LOWERCASE_OUTPUT_LABEL_NAMES` | Lowercase the output metric label names. Applies to default format and `labels`. Defaults to false.


Using with Prometheus
---------------------

Minimal example config:

```
global:
 scrape_interval: 10s
 evaluation_interval: 10s
scrape_configs:
 - job_name: 'jmx'
   static_configs:
    - targets:
      - 127.0.0.1:5556
```
