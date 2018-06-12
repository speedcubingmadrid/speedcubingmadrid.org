#!/usr/bin/env bash

# /!\ assumed to be executed by root!

create_cert() {
  certbot certonly --webroot -w /home/afs/speedcubingfrance.org/public -d www.speedcubingfrance.org
}

renew_cert() {
  certbot renew
}

cd "$(dirname "$0")"/..

allowed_commands="create_cert renew_cert"
source scripts/_parse_args.sh
