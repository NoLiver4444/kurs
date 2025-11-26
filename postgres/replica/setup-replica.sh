#!/bin/bash
set -e

echo "=== SETTING UP POSTGRESQL REPLICA ==="

# Wait for master to be ready
echo "Waiting for master to be available..."
until pg_isready -h postgres-master -p 5432 -U admin; do
  echo "Master not available, waiting..."
  sleep 2
done

echo "Master available! Starting replication setup..."

# Stop PostgreSQL
echo "Stopping PostgreSQL..."
pg_ctl -D /var/lib/postgresql/data -m fast -w stop

# Clean replica data
echo "Cleaning replica data..."
rm -rf /var/lib/postgresql/data/*

# Copy data from master
echo "Copying data from master..."
PGPASSWORD=secretpassword pg_basebackup -h postgres-master -p 5432 -U admin -D /var/lib/postgresql/data -P --wal-method=stream -R

# Create standby.signal for replica mode
echo "Creating replica configuration..."
touch /var/lib/postgresql/data/standby.signal

# Configure primary_conninfo
echo "primary_conninfo = 'host=postgres-master port=5432 user=admin password=secretpassword'" >> /var/lib/postgresql/data/postgresql.conf

echo "Starting replica..."
pg_ctl -D /var/lib/postgresql/data -w start

echo "=== REPLICA SETUP COMPLETED ==="
