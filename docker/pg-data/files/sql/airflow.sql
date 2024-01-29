CREATE DATABASE airflow;

\c airflow

CREATE USER airflow_user WITH NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT LOGIN NOREPLICATION NOBYPASSRLS;
GRANT airflow_user to postgres;
GRANT CONNECT,CREATE ON DATABASE airflow TO airflow_user;

CREATE SCHEMA IF NOT EXISTS jobs AUTHORIZATION airflow_user;

ALTER ROLE airflow_user IN DATABASE airflow SET search_path TO jobs,"$user",public;

ALTER USER airflow_user WITH PASSWORD 'password';

