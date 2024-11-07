FROM python:3.11-alpine

COPY ./ /app

RUN pip install --no-cache-dir -r /app/requirements.txt && \
    adduser -D -u 1001 flask && \
    chown -R flask:flask /app && \
    chmod +x /app/entrypoint.sh

WORKDIR /app

EXPOSE 8000

USER flask

CMD ["python", "app.py"]