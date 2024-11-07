FROM python:3.11-alpine as builder

# Встановлюємо залежності для компіляції
RUN apk add --no-cache gcc musl-dev libffi-dev python3-dev postgresql-dev zlib-dev

# Копіюємо requirements.txt
COPY ./requirements.txt /app/requirements.txt

# Встановлюємо залежності Python
RUN pip install --no-cache-dir -r /app/requirements.txt

# Переходимо до іншого етапу
FROM python:3.11-alpine

# Встановлюємо необхідні бібліотеки
RUN apk add --no-cache libpq

# Копіюємо встановлені пакети з попереднього етапу
COPY --from=builder /usr/local/lib/python3.11/site-packages/ /usr/local/lib/python3.11/site-packages/
COPY --from=builder /usr/local/bin/ /usr/local/bin/

# Копіюємо код
COPY . /app

WORKDIR /app

# Налаштовуємо змінні оточення
ENV PYTHONUNBUFFERED 1

ENTRYPOINT ["/app/entrypoint.sh"]
