# アプリケーション起動手順
1. 任意のディレクトリにリポジトリを複製してください。
```
$ git clone https://github.com/icchankun/ruby-sinatra.git
```

2. ダウンロードされたディレクトリに移動してください。
```
$ cd ruby-sinatra
```

3. アプリケーションの起動に必要なGemをインストールしてください。
```
$ bundle install
```

4. 下のURLの記事（日本PostgreSQLユーザ会）を参考にし、最新版のPostgreSQLをインストール、起動してください。<br>
https://www.postgresql.jp/download

5. PostgreSQLにログインしてください。
```
$ psql -U ${USER} -d postgres
```

6. ユーザー(sample)を作成してください。
```
postgres=# CREATE USER sample WITH SUPERUSER;
```

8. データベース(ruby_sinatra)を作成してください。
```
postgres=# CREATE DATABASE ruby_sinatra OWNER sample;
```

7. PostgreSQLから一度ログアウトし、sampleでログインしなおしてください。その時、データベースはruby_sinatraを指定してください。
```
postgres=# \q
$ psql -U sample -d ruby_sinatra
```

8. ruby_sinatraにテーブルを作成してください。
```
ruby_sinatra=# CREATE TABLE memos (
id SERIAL PRIMARY KEY,
title text NOT NULL,
body text NOT NULL,
created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

9. PostgreSQLからログアウトし、アプリケーションを起動させてください。
```
ruby_sinatra=# \q
$ bundle exec ruby memos.rb
```

10. 下のURLにアクセスしてください。<br>
http://localhost:4567/memos
