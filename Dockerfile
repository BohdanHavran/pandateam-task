FROM python:3.8.18-alpine as Zhytomyr
RUN apk add --update --virtual .build-deps \
    build-base \
    postgresql-dev \
    python3-dev \
    libpq

COPY ./requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt

FROM python:3.8.18-alpine

RUN apk add libpq

COPY --from=Zhytomyr /usr/local/lib/python3.8/site-packages/ /usr/local/lib/python3.8/site-packages/
COPY --from=Zhytomyr /usr/local/bin/ /usr/local/bin/

COPY . /app

WORKDIR /app

ENV PYTHONUNBUFFERED 1

ENTRYPOINT ["/app/entrypoint.sh"]