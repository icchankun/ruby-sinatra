require 'sinatra'
require 'sinatra/reloader'
require 'json'

configure do
  # HTTPメソッドのPATCH/DELETEを使えるようにする。
  enable :method_override
end

helpers do
  # 特定のメールデータのインデックスを取得。
  def index
    params[:id].to_i - 1
  end

  # JSONファイルへメモデータを書き込む。
  def write_to_file
    @hash[:memos] = @memos
    File.open("memos.json", "w") do |file|
      JSON.dump(@hash, file)
    end
  end
end

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

  write_to_file

  # メモデータを保存後、そのメモの詳細画面に遷移。
  id = @memos.size
  redirect "/memos/#{id}"
end

get '/memos/:id' do
  # インデックスからメモを特定。
  @memo = @memos[index]

  @title = "show memo | メモアプリ"
  erb :show
end

get '/memos/:id/edit' do
  # インデックスからメモを特定。
  @memo = @memos[index]

  @title = "Edit memo | メモアプリ"
  erb :edit
end

patch '/memos/:id' do
  # フォームに入力された更新用のメモデータを既存のメモデータに反映。
  @memos[index][:title] = params[:title]
  @memos[index][:body] = params[:body]

  write_to_file

  # メモデータを編集後、そのメモの詳細画面に遷移。
  redirect "/memos/#{params[:id]}"
end
