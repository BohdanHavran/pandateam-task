FROM python:3.11-alpine as builder

RUN apk add --update --virtual .build-deps \
    build-base \
    postgresql-dev \
    python3-dev \
    libpq

COPY ./requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

FROM python:3.11-alpine

RUN apk add --no-cache libpq bash

RUN adduser -D -u 1001 django

COPY --from=builder /usr/local/lib/python3.11/site-packages/ /usr/local/lib/python3.11/site-packages/
COPY --from=builder /usr/local/bin/ /usr/local/bin/

COPY ./ /app

RUN chown -R django:django /app && \
    chmod +x /app/entrypoint.sh

WORKDIR /app

EXPOSE 8000

USER django

ENTRYPOINT ["/app/entrypoint.sh"]