#!/usr/bin/env bash

# /!\ assumed to be executed by root!

create_cert() {
  certbot certonly --webroot -w /home/ams/speedcubingmadrid.org/public -d www.speedcubingmadrid.org
}

renew_cert() {
  certbot renew
}

cd "$(dirname "$0")"/..

allowed_commands="create_cert renew_cert"
source scripts/_parse_args.sh
