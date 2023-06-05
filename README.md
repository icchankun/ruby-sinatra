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

4. アプリケーションを起動させてください。
```
bundle exec ruby memos.rb -p 4567
```

5. 下記のURLにアクセスしてください。<br>
http://localhost:4567/memos
