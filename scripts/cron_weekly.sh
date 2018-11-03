#!/usr/bin/env bash

/home/ams/speedcubingmadrid.org/scripts/prod_cert.sh renew_cert
# Restarting nginx is necessary for the potential new certificate to be taken into account.
service nginx restart
