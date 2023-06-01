require 'sinatra'
require 'sinatra/reloader'
require 'json'

before do
  # JSONファイルからメモデータを読み込む。
  File.open("memos.json", "r") do |file|
    # JSONのメモデータをキーがシンボルのハッシュに変更。
    @hash = JSON.load(file, nil, symbolize_names: true, create_additions: false)
    @memos = @hash[:memos]
  end
end

get '/' do
  @title = "Top | メモアプリ"
  erb :index
end

get '/memos/new' do
  @title = "New memo | メモアプリ"
  erb :new
end

post '/memos' do
  # フォームに入力されたメモデータを取得し、ハッシュとして格納.
  title = params[:title]
  body = params[:body]
  memo = {title: "#{title}", body: "#{body}"}
  @memos << memo
  @hash[:memos] = @memos

  # JSONファイルへメモデータを書き込む。
  File.open("memos.json", "w") do |file|
    JSON.dump(@hash, file)
  end

  # メモデータを保存後、そのメモの詳細画面に遷移。
  id = @memos.size
  redirect "/memos/#{id}"
end

get '/memos/:id' do
  # :idからindexを取得し、メモを特定する。
  index = params[:id].to_i - 1
  @memo = @memos[index]

  @title = "show memo | メモアプリ"
  erb :show
end
