require 'sinatra'
require 'sinatra/reloader'
require 'json'

get '/' do
  # JSONファイルからメモデータを読み込み
  File.open("memos.json", "r") do |file|
    hash = JSON.load(file)
    @memos = hash["memos"]
  end

  @title = "Top | メモアプリ"
  erb :index
end

get '/memos/:id' do
  # JSONファイルからメモデータを読み込み
  File.open("memos.json", "r") do |file|
    hash = JSON.load(file)
    @memos = hash["memos"]
  end

  # :idからindexを取得し、メモを特定する。
  index = params[:id].to_i - 1
  @memo = @memos[index]

  @title = "show memo | メモアプリ"
  erb :show
end
