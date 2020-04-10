#!/bin/sh

set -eu

resolver=$(awk '/^nameserver/ { print $2; exit; }' /etc/resolv.conf)
sed -i "s;{{DNS_RESOLVER}};$resolver;g" /etc/nginx/conf.d/app.conf

sed -i "s;{{ATHENA_SERVICE_HOST}};$ATHENA_SERVICE_HOST;g" /etc/nginx/conf.d/app.conf
sed -i "s;{{PROMETHEUS_SERVICE_HOST}};$PROMETHEUS_SERVICE_HOST;g" /etc/nginx/conf.d/app.conf

echo "Running nginx .."
/usr/local/openresty/bin/openresty -g "daemon off; pid /dev/null;"
