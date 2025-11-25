-- Создаем пользователя для репликации
CREATE USER replica_user WITH REPLICATION LOGIN PASSWORD 'replica_password';

-- Создаем тестовую базу и таблицу для демонстрации
\c mydb;

CREATE TABLE IF NOT EXISTS test_data (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Вставляем тестовые данные
INSERT INTO test_data (name) VALUES 
('Тестовая запись 1'),
('Тестовая запись 2'),
('Тестовая запись 3');

-- Настраиваем репликацию
ALTER SYSTEM SET wal_level = replica;
ALTER SYSTEM SET max_wal_senders = 10;
ALTER SYSTEM SET max_replication_slots = 10;

-- Создаем слот репликации
SELECT pg_create_physical_replication_slot('replica_slot');