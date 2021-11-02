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
export NC_DB_JSON_FILE=/tmp/db.config.json
export NC_MAILER=true
export NC_MAILER_FROM=$CLOUDRON_MAIL_FROM
export NC_MAILER_HOST=$CLOUDRON_MAIL_SMTP_SERVER
export NC_MAILER_PORT=$CLOUDRON_MAIL_SMTPS_PORT
export NC_MAILER_SECURE=false
export NC_MAILER_USER=$CLOUDRON_MAIL_SMTP_USERNAME
export NC_MAILER_PASS=$CLOUDRON_MAIL_SMTP_PASSWORD
export NC_TOOL_DIR=/app/data


NC_AUTH_JWT_SECRET=$(cat /app/data/jwt.secret)

cat << EOF > /tmp/db.config.json
    {
  "client": "pg",
  "connection": {
    "host": "${CLOUDRON_POSTGRESQL_HOST}",
    "port": "${CLOUDRON_POSTGRESQL_PORT}",
    "user": "${CLOUDRON_POSTGRESQL_USERNAME}",
    "password": "${CLOUDRON_POSTGRESQL_PASSWORD}",
    "database": "${CLOUDRON_POSTGRESQL_USERNAME}",
    "ssl": true
  }
}
EOF

mkdir -p /app/data

HOME=/app/data npm run start