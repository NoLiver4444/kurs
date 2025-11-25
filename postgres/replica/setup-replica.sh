#!/bin/bash
set -e

echo "Настройка PostgreSQL реплики..."

# Ждем пока мастер будет готов
until pg_isready -h postgres-master -p 5432 -U admin; do
  echo "Ожидание мастера..."
  sleep 2
done

# Останавливаем PostgreSQL чтобы скопировать данные
pg_ctl -D /var/lib/postgresql/data -m fast -w stop

# Очищаем данные реплики
rm -rf /var/lib/postgresql/data/*

# Копируем данные с мастера
pg_basebackup -h postgres-master -p 5432 -U replica_user -D /var/lib/postgresql/data -P --wal-method=stream

# Настраиваем репликацию
cat > /var/lib/postgresql/data/recovery.conf << EOF
standby_mode = 'on'
primary_conninfo = 'host=postgres-master port=5432 user=replica_user password=replica_password'
primary_slot_name = 'replica_slot'
trigger_file = '/tmp/promote_trigger'
EOF

# Запускаем PostgreSQL
pg_ctl -D /var/lib/postgresql/data -w start

echo "Реплика настроена и запущена!"