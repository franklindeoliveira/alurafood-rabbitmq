#!/bin/bash
set -e

rabbitmq-server -detached

echo "Aguardando RabbitMQ responder ping..."
until rabbitmq-diagnostics -q ping; do
  sleep 2
done

echo "RabbitMQ master pronto."

tail -f /dev/null

