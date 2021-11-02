#!/bin/bash

set -eu


# ensure that data directory is owned by 'cloudron' user
chown -R cloudron:cloudron /app/data

echo "Starting Node.js app"


# run the app as user 'cloudron'
export NC_DB="$(echo $CLOUDRON_POSTGRESQL_URL)"
export DATABASE_URL=$NC_DB
export VIRTUAL_HOST=$CLOUDRON_APP_ORIGIN
export NC_PUBLIC_URL=$CLOUDRON_APP_ORIGIN
#export NC_DASHBOARD_URL=
export NC_MAILER=true
export NC_MAILER_FROM=$CLOUDRON_MAIL_FROM
export NC_MAILER_HOST=$CLOUDRON_MAIL_SMTP_SERVER
export NC_MAILER_PORT=$CLOUDRON_MAIL_SMTPS_PORT
export NC_MAILER_SECURE=true
export NC_MAILER_USER=$CLOUDRON_MAIL_SMTP_USERNAME
export NC_MAILER_PASS=$CLOUDRON_MAIL_SMTP_PASSWORD



echo "Starting app now";
gosu cloudron:cloudron npm run start