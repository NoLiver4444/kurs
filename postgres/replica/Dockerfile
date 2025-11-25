FROM postgres:15

# Устанавливаем дополнительные утилиты
RUN apt-get update && apt-get install -y \
    postgresql-15-wal2json \
    && rm -rf /var/lib/apt/lists/*

# Копируем скрипт настройки реплики
COPY setup-replica.sh /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/setup-replica.sh

# Скрипт будет выполнен автоматически при первом запуске