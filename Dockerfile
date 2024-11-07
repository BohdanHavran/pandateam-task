FROM python:3.11-alpine

WORKDIR /app

RUN apk add --no-cache bash

COPY ./ ./

RUN adduser -D -u 1001 django && \
    pip install --no-cache-dir -r requirements.txt && \
    chown -R django:django /app

EXPOSE 8000

USER django

CMD ["sh", "-c", ".script.sh"]
