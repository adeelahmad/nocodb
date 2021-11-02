#!/bin/bash

#set -eu


# ensure that data directory is owned by 'cloudron' user
chown -R cloudron:cloudron /app/data

echo "Starting Node.js app"


# run the app as user 'cloudron'

export NC_DB="$(echo $CLOUDRON_POSTGRESQL_URL)?sslmode=disabled&ssl=false"
export DATABASE_URL=$NC_DB
export SMTP_HOST=$CLOUDRON_MAIL_SMTP_SERVER
export SMTP_PORT=$CLOUDRON_MAIL_SMTP_PORT
export SMTP_USERNAME=$CLOUDRON_MAIL_TO
export SMTP_PASSWORD=$CLOUDRON_MAIL_SMTP_PASSWORD
export SMTP_FROM_EMAIL=$CLOUDRON_MAIL_TO
export SMTP_REPLY_EMAIL=$CLOUDRON_MAIL_TO
export SMTP_TLS_CIPHERS=
export SMTP_SECURE=false
export VIRTUAL_HOST=$CLOUDRON_APP_ORIGIN
#export NC_PUBLIC_URL=$CLOUDRON_APP_ORIGIN
#export NC_DASHBOARD_URL=
export NC_DB_JSON_FILE=/run/db.config.json


json=$(cat <<-END
    {
  "client": "pg",
  "connection": {
    "host": "${CLOUDRON_POSTGRESQL_HOST}",
    "port": "${CLOUDRON_POSTGRESQL_PORT}",
    "user": "${CLOUDRON_POSTGRESQL_USERNAME}",
    "password": "${CLOUDRON_POSTGRESQL_PASSWORD}",
    "database": "${CLOUDRON_POSTGRESQL_USERNAME}",
    "ssl": {
      "rejectUnauthorized": false
    }
  }
}
END

echo $json > /run/db.config.json

mkdir -p /app/data

HOME=/app/data npm run start