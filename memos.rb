# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

helpers do
  # 特定のメモデータのインデックスを取得。
  def index
    params[:id].to_i - 1
  end

  def fetch_memos
    stored_format_data = File.read('memos.json')
    return [] if stored_format_data == ''

    JSON.parse(stored_format_data, symbolize_names: true)[:memos]
  end

  def write_to_file(memos)
    File.open('memos.json', 'w') do |file|
      JSON.dump({ memos: }, file)
    end
  end

  # タイトルタグの中身を生成。
  def title(page_title)
    "#{page_title} | メモアプリ"
  end
end

not_found do
  'This is nowhere to be found.'
end

get '/memos' do
  @memos = fetch_memos
  @page_title = 'Top'
  erb :index
end

get '/memos/new' do
  @page_title = 'New memo'
  erb :new
end

post '/memos' do
  memos = fetch_memos
  title = params[:title]
  body = params[:body]
  memos << { title:, body:, is_active: true }
  write_to_file(memos)
  id = memos.size
  redirect "/memos/#{id}"
end

get '/memos/:id' do
  @memo = fetch_memos[index]
  pass if !@memo
  @page_title = 'show memo'
  erb :show
end

get '/memos/:id/edit' do
  @memo = fetch_memos[index]
  pass if !@memo
  @page_title = 'Edit memo'
  erb :edit
end

patch '/memos/:id' do
  memos = fetch_memos
  memos[index][:title] = params[:title]
  memos[index][:body] = params[:body]
  write_to_file(memos)
  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  memos = fetch_memos
  memos[index][:is_active] = false
  write_to_file(memos)
  redirect '/memos'
end
