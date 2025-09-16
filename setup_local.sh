#!/usr/bin/env bash
set -e
echo 'Starting local setup...'
# start postgres via docker
docker run --rm --name local_pg -e POSTGRES_PASSWORD=pass -e POSTGRES_USER=user -e POSTGRES_DB=dbname -p 5432:5432 -d postgres:15
# wait for pg
echo 'Waiting for Postgres to be ready...'
sleep 5
# run migrations
psql "$DATABASE_URL" -f db/migrations/001_init.sql || true
npm ci || true
node src/index.js &
echo 'App started in background'
