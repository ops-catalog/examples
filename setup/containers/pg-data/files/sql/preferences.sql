CREATE DATABASE preferences;

\c preferences

CREATE SCHEMA IF NOT EXISTS notifications;

CREATE TABLE notifications.catalog
(
    ID      VARCHAR(255) PRIMARY KEY,
    CONTENT TEXT
);

CREATE SCHEMA IF NOT EXISTS cms;

CREATE TABLE cms.catalog
(
    ID      VARCHAR(255) PRIMARY KEY,
    CONTENT TEXT
);


