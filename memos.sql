# ユーザーの作成
CREATE USER sample WITH SUPERUSER;

# データベースの作成
CREATE DATABASE ruby_sinatra OWNER sample;

# テーブルの作成
CREATE TABLE memos (
    id         SERIAL PRIMARY KEY,
    title      text NOT NULL,
    body       text NOT NULL,
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);
