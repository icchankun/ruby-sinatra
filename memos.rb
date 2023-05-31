require 'sinatra'
require 'sinatra/reloader'
require 'json'

before do
  # JSONファイルからメモデータを読み込む。
  File.open("memos.json", "r") do |file|
    # JSONのメモデータをキーがシンボルのハッシュに変更。
    hash = JSON.load(file, nil, symbolize_names: true, create_additions: false)
    @memos = hash[:memos]
  end
end

get '/' do
  @title = "Top | メモアプリ"
  erb :index
end

get '/memos/:id' do
  # :idからindexを取得し、メモを特定する。
  index = params[:id].to_i - 1
  @memo = @memos[index]

  @title = "show memo | メモアプリ"
  erb :show
end
