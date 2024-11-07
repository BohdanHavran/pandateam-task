FROM python:3.11-alpine

WORKDIR /app

RUN apk add --no-cache bash

COPY ./ /app

RUN adduser -D -u 1001 django && \
    pip install --no-cache-dir -r requirements.txt && \
    chown -R django:django /app && \
    chmod +x /app/entrypoint.sh  # Add this line

EXPOSE 8000

USER django

ENTRYPOINT ["/app/entrypoint.sh"]
