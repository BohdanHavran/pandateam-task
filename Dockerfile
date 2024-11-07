FROM python:3.11-alpine

RUN apk add --update --virtual .build-deps \
    build-base \
    postgresql-dev \
    python3-dev \
    libpq \
    bash

COPY ./ /app

RUN pip install --no-cache-dir -r /app/requirements.txt && \
    adduser -D -u 1001 django && \
    chown -R django:django /app && \
    chmod +x /app/entrypoint.sh

WORKDIR /app

EXPOSE 8000

USER django

ENTRYPOINT ["/app/entrypoint.sh"]