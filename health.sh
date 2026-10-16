#!/bin/bash

set -euo pipefail

set -a
source .env
set +a

set -x

docker compose ps --services --status=running | grep -q 'dnscrypt-proxy'
docker compose ps --format json | jq '. | select(.Service == "pihole").Health' | grep -q 'healthy'

dig @0.0.0.0 -p $DNSCRYPT_HOST_DNS_PORT google.com
dig @0.0.0.0 -p $PIHOLE_HOST_DNS_PORT google.com
