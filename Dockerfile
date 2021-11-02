FROM cloudron/base:3.0.0@sha256:455c70428723e3a823198c57472785437eb6eab082e79b3ff04ea584faf46e92

ARG VERSION "0.81.1"

ENV APP_DIR /app/code

RUN mkdir -p /app

RUN git clone https://github.com/nocodb/nocodb-seed ${APP_DIR}

WORKDIR ${APP_DIR}

RUN apt -y install sqlite3

RUN mkdir -p /app/data

RUN npm install

RUN rm .env && touch /app/data/env && \
    ln -s /app/data/env ${APP_DIR}/.env


COPY start.sh /app/code/start.sh


ENV DEFAULT_LANGUAGE en_US
ENV NODE_ENV production
ENV PORT 8080
ENV VIRTUAL_PORT $PORT
ENV PGSSLMODE disabled
ENV TS_ENABLED true
ENV HOST 0.0.0.0
ENV NC_NO_AUTH true
ENV NC_DISABLE_TELE true


RUN sqlite3 /app/data/noco.db "VACUUM;" && \
    ln -s /app/data/noco.db /app/code/noco.db


RUN chmod 755 /app/code/start.sh

RUN chown -R cloudron:cloudron /app

EXPOSE 8080

USER cloudron

CMD [ "/app/code/start.sh" ]