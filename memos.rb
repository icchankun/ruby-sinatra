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
