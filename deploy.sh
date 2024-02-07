#!/usr/bin/env bash

set -euo pipefail

function usage {
  echo "Usage: $0 <env>" >&2
  exit 1
}

[[ $# -ge 1 ]] || usage
environment=$1
shift

service=web-analytics

echo "Deploying $service-$environment... " >&2
echo >&2

export NAMESPACE="$service-$environment"
export MANAGED_DOMAIN="$service-$environment.$RUNTIME_DOMAIN"
export BASE_URL="${BASE_URL:-https://$MANAGED_DOMAIN}"
export MAILER_EMAIL="$MAILER_EMAIL"
export SMTP_HOST_ADDR="$SMTP_HOST_ADDR"
export SMTP_HOST_PORT="$SMTP_HOST_PORT"
BASE64_SECRET_KEY_BASE=$(echo -n "$SECRET_KEY_BASE" | openssl base64 -A)
BASE64_POSTGRES_PASSWORD=$(echo -n "$POSTGRES_PASSWORD" | openssl base64 -A)
BASE64_CLICKHOUSE_PASSWORD=$(echo -n "$CLICKHOUSE_PASSWORD" | openssl base64 -A)
BASE64_SMTP_EMAIL=$(echo -n "$SMTP_EMAIL" | openssl base64 -A)
BASE64_SMTP_PASSWORD=$(echo -n "$SMTP_PASSWORD" | openssl base64 -A)

export BASE64_SECRET_KEY_BASE BASE64_POSTGRES_PASSWORD BASE64_CLICKHOUSE_PASSWORD BASE64_SMTP_EMAIL BASE64_SMTP_PASSWORD

# shellcheck disable=SC2016
variables='$NAMESPACE
  $MANAGED_DOMAIN
  $BASE_URL
  $MAILER_EMAIL
  $SMTP_HOST_ADDR
  $SMTP_HOST_PORT
  $BASE64_SECRET_KEY_BASE
  $BASE64_CLICKHOUSE_PASSWORD
  $BASE64_POSTGRES_PASSWORD
  $BASE64_SMTP_EMAIL
  $BASE64_SMTP_PASSWORD'

envsubst "$variables" <kubernetes.yaml | kubectl apply -f -

echo >&2
echo 'Deployment complete' >&2
