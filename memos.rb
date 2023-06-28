# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'
require 'pg'

helpers do
  def fetch_memos
    connection = PG.connect(dbname: 'ruby_sinatra')
    result = connection.exec('SELECT * FROM memos')

    result.to_a.map { |hash| hash.transform_keys(&:to_sym) }
  end

  def find_memo(id)
    fetch_memos.find { |memo| memo[:id] == id }
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
  'このURLのページは存在しません。'
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
  @memo = find_memo(params[:id])
  pass if !@memo

  @page_title = 'show memo'

  erb :show
end

get '/memos/:id/edit' do
  @memo = find_memo(params[:id])
  pass if !@memo

  @page_title = 'Edit memo'

  erb :edit
end

patch '/memos/:id' do
  memos = fetch_memos

  memo = find_memo(params[:id])

  index = memos.index(memo)
  memos[index][:title] = params[:title]
  memos[index][:body] = params[:body]
  write_to_file(memos)

  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  memos = fetch_memos

  memo = find_memo(params[:id])

  index = memos.index(memo)
  memos.delete_at(index)
  write_to_file(memos)

  redirect '/memos'
end
