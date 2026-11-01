#!/bin/bash
set -e

echo "START RUN Library API ==="

echo "1. clear space..."
docker compose down --rmi local 2>/dev/null || true

mkdir -p host_logs

# контейнер пише під UID 1000, хост-юзер — під своїм.
chmod 777 host_logs 2>/dev/null || true
touch host_logs/.gitkeep

echo "2. docker compose up..."
docker compose up -d --build

echo "3. очікування готовності API(Spring Boot піднімається)..."
API_READY=0
for i in $(seq 1 30); do
  # пробуємо достукатися до API. -s ховає зайве, -f видає помилку якщо код не 200
  if curl -sf http://localhost:8080/api/books > /dev/null 2>&1; then
    echo "  API успішно відповідає(спроба $i)"
    API_READY=1
    break
  fi
  echo "  ...чекаємо($i/30)"
  sleep 2
done

if [ "$API_READY" -ne 1 ]; then
  echo "ПОМИЛКА: API не відповів за 60 секунд."
  echo "дивись логи тут: docker compose logs java-app"
  exit 1
fi

echo "4. статус контейнерів:"
docker compose ps

echo "Well done"
echo "додаток успішно розгорнуто"
echo "API доступно за адресою: http://localhost:8080/api/books"
echo "pgAdmin доступний за адресою: http://localhost:5050 (логін: admin@lib.com, пароль: admin)"
