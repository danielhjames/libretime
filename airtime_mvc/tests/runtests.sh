#!/bin/bash

rabbitmqctl start_app

RABBITMQ_VHOST="/airtime"
RABBITMQ_USER="airtime_tests"
RABBITMQ_PASSWORD="airtime_tests"
EXCHANGES="airtime-pypo|pypo-fetch|airtime-media-monitor|media-monitor"

rabbitmqctl list_vhosts | grep $RABBITMQ_VHOST
RESULT="$?"

if [ $RESULT = "0" ]; then
    rabbitmqctl delete_vhost $RABBITMQ_VHOST
    rabbitmqctl delete_user $RABBITMQ_USER
fi

rabbitmqctl add_vhost $RABBITMQ_VHOST
rabbitmqctl add_user $RABBITMQ_USER $RABBITMQ_PASSWORD
rabbitmqctl set_permissions -p $RABBITMQ_VHOST $RABBITMQ_USER "$EXCHANGES" "$EXCHANGES" "$EXCHANGES"

export RABBITMQ_USER
export RABBITMQ_PASSWORD
export RABBITMQ_VHOST

export AIRTIME_UNIT_TEST="1"
phpunit --log-junit test_results.xml

