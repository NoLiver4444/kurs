-- Создаём пользователя для репликации
CREATE USER replica_user WITH REPLICATION LOGIN PASSWORD 'replica_password';

-- Создаём тестовую таблицу
CREATE TABLE IF NOT EXISTS test_data (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Вставляем начальные данные
INSERT INTO test_data (name) VALUES
('Тестовая запись 1'),
('Тестовая запись 2'),
('Тестовая запись 3');

-- Настраиваем параметры репликации
ALTER SYSTEM SET wal_level = replica;
ALTER SYSTEM SET max_wal_senders = 10;
ALTER SYSTEM SET max_replication_slots = 10;