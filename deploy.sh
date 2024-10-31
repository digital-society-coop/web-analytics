#!/usr/bin/env bash

set -euo pipefail

function usage {
  echo "Usage: $0 <env>" >&2
  exit 1
}

[[ $# -ge 1 ]] || usage
environment=$1
shift

export SERVICE=web-analytics

echo "Deploying $SERVICE-$environment... " >&2
echo >&2

export NAMESPACE="runtime"
export MANAGED_DOMAIN="$SERVICE.$RUNTIME_DOMAIN"
BASE64_SECRET=$(echo -n "$SECRET" | openssl base64 -A)
BASE64_POSTGRES_PASSWORD=$(echo -n "$POSTGRES_PASSWORD" | openssl base64 -A)

export BASE64_SECRET BASE64_POSTGRES_PASSWORD

# shellcheck disable=SC2016
variables='$SERVICE
  $NAMESPACE
  $MANAGED_DOMAIN
  $BASE64_SECRET
  $BASE64_POSTGRES_PASSWORD'

envsubst "$variables" <kubernetes.yaml | kubectl apply -f -

echo >&2
echo 'Deployment complete' >&2
