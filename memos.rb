# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

helpers do
  # 特定のメモデータのインデックスを取得。
  def index
    params[:id].to_i - 1
  end

  # インデックスにより、メモを特定。
  def memo
    @memo = @memos[index]
    pass if !@memo
  end

  def write_to_file
    @hash[:memos] = @memos
    File.open('memos.json', 'w') do |file|
      JSON.dump(@hash, file)
    end
  end

  # タイトルタグの中身を生成。
  def title(page_title)
    @title = "#{page_title} | メモアプリ"
  end
end

before do
  file = File.read('memos.json')
  @hash = JSON.parse(file, symbolize_names: true)
  @memos = @hash[:memos]
end

not_found do
  'This is nowhere to be found.'
end

get '/memos' do
  title('Top')
  erb :index
end

get '/memos/new' do
  title('New memo')
  erb :new
end

post '/memos' do
  title = params[:title]
  body = params[:body]
  memo = { title:, body: }
  @memos << memo
  write_to_file
  id = @memos.size
  redirect "/memos/#{id}"
end

get '/memos/:id' do
  memo
  title('show memo')
  erb :show
end

get '/memos/:id/edit' do
  memo
  title('Edit memo')
  erb :edit
end

patch '/memos/:id' do
  @memos[index][:title] = params[:title]
  @memos[index][:body] = params[:body]
  write_to_file
  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  @memos.delete_at(index)
  write_to_file
  redirect '/memos'
end
