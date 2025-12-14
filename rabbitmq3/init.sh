#!/bin/bash
set -e

rabbitmq-server -detached

echo "Aguardando RabbitMQ responder ping..."
until rabbitmq-diagnostics -q ping; do
  sleep 2
done

echo "Parando app RabbitMQ..."
rabbitmqctl stop_app

echo "Resetando nó..."
rabbitmqctl reset

echo "Entrando no cluster..."
rabbitmqctl join_cluster rabbit@rabbitmq1

echo "Subindo app RabbitMQ..."
rabbitmqctl start_app

tail -f /dev/null

