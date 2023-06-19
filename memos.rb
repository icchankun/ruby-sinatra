# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'

helpers do
  def fetch_memos
    stored_format_data = File.read('memos.json')
    return [] if stored_format_data.empty?

    JSON.parse(stored_format_data, symbolize_names: true)[:memos]
  end

  def find_memo
    fetch_memos.find { |memo| memo[:id] == params[:id] }
  end

  def write_to_file(memos)
    File.open('memos.json', 'w') do |file|
      JSON.dump({ memos: }, file)
    end
  end

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
  memo = { id: SecureRandom.uuid, title:, body: }
  memos << memo
  write_to_file(memos)
  redirect "/memos/#{memo[:id]}"
end

get '/memos/:id' do
  @memo = find_memo
  pass if !@memo
  @page_title = 'show memo'
  erb :show
end

get '/memos/:id/edit' do
  @memo = find_memo
  pass if !@memo
  @page_title = 'Edit memo'
  erb :edit
end

patch '/memos/:id' do
  memos = fetch_memos
  index = memos.index(find_memo)
  memos[index][:title] = params[:title]
  memos[index][:body] = params[:body]
  write_to_file(memos)
  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  memos = fetch_memos
  index = memos.index(find_memo)
  memos.delete_at(index)
  write_to_file(memos)
  redirect '/memos'
end
