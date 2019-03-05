#!/bin/sh

CONFIG_DIR="$JMX_EXPORTER_PATH/config"
CONFIG_FILE="$CONFIG_DIR/config.yaml"
CONFIG_TEMPLATE="$CONFIG_DIR/config.yaml.template"

# Main JAR
test -f "$JMX_EXPORTER_JAR" || { echo "INTERNAL DOCKER ERROR: JMX exporter jar file not found: $JMX_EXPORTER_JAR - This indicates a problem with the Docker build."; exit 1; }

# Debug block...
  echo "DEBUG: Docker image configuration."
  echo "JMX_EXPORTER_VERSION: $JMX_EXPORTER_VERSION"
  echo "JMX_EXPORTER_JAR: $JMX_EXPORTER_JAR"
  echo ""
  echo "DEBUG: Runtime environment variables set/received..."
  echo "JMX_EXPORTER_VERSION: $JMX_EXPORTER_VERSION"
  echo "SERVICE_PORT: $SERVICE_PORT"
  echo "START_DELAY_SECONDS: $START_DELAY_SECONDS"
  echo "JMX_HOST_PORT: $JMX_HOST_PORT"
  echo "JMX_USERNAME: $JMX_USERNAME"
  echo "JMX_PASSWORD: $JMX_PASSWORD"
  echo "JMX_SSL: $JMX_SSL"
  echo "LOWERCASE_OUTPUT_NAME: $LOWERCASE_OUTPUT_NAME"
  echo "LOWERCASE_OUTPUT_LABEL_NAMES: $LOWERCASE_OUTPUT_LABEL_NAMES"
  echo "WHITELIST_OBJECT_NAMES: $WHITELIST_OBJECT_NAMES"
  echo "BLACKLIST_OBJECT_NAMES: $BLACKLIST_OBJECT_NAMES"
  echo "JVM_LOCAL_OPTS: $JVM_LOCAL_OPTS"
  echo

# Service launch
echo "Starting Service..."
echo java $JVM_LOCAL_OPTS -jar $JMX_EXPORTER_JAR $SERVICE_PORT $CONFIG_FILE
dockerize -template "$CONFIG_TEMPLATE:$CONFIG_FILE" \
  java $JVM_LOCAL_OPTS -jar $JMX_EXPORTER_JAR $SERVICE_PORT $CONFIG_FILE
