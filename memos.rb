# frozen_string_literal: true

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
    File.open('memos.json', 'w') do |file|
      JSON.dump(@hash, file)
    end
  end

  # titleタグの中身を生成。
  def title(page_title)
    @title = "#{page_title} | メモアプリ"
  end
end

before do
  # JSONファイルからメモデータを読み込む。
  file = File.read('memos.json')
  # JSONのメモデータをキーがシンボルのハッシュに変更。
  @hash = JSON.parse(file, symbolize_names: true)
  @memos = @hash[:memos]
end

get '/' do
  title('Top')
  erb :index
end

get '/memos/new' do
  title('New memo')
  erb :new
end

post '/memos' do
  # フォームに入力されたメモデータを取得し、ハッシュとして格納.
  title = params[:title]
  body = params[:body]
  memo = { title:, body: }
  @memos << memo

  write_to_file

  # メモデータを保存後、そのメモの詳細画面に遷移。
  id = @memos.size
  redirect "/memos/#{id}"
end

get '/memos/:id' do
  # インデックスからメモを特定。
  @memo = @memos[index]

  title('show memo')
  erb :show
end

get '/memos/:id/edit' do
  # インデックスからメモを特定。
  @memo = @memos[index]

  title('Edit memo')
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

delete '/memos/:id' do
  # インデックスからメモを特定し、そのメモを削除。
  @memos.delete_at(index)

  write_to_file

  # メモデータを削除後、メモ一覧画面に遷移。
  redirect '/'
end
