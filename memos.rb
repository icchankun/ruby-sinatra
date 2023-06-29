# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'
require 'pg'

helpers do
  def connection
    PG.connect(dbname: 'ruby_sinatra')
  end

  def fetch_memos
    memos = connection.exec('SELECT * FROM memos')
    memos.to_a.map { |memo| memo.transform_keys(&:to_sym) }
  end

  def find_memo(id)
    memo = connection.exec_params('SELECT * FROM memos WHERE id = $1', [id])
    pass if memo.to_a.empty?
    memo[0].transform_keys(&:to_sym)
  end

  def lastest_memo_id(memos)
    memos[memos.length - 1][:id]
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
  connection.exec_params('INSERT INTO memos (title, body) VALUES ($1, $2)', [params[:title], params[:body]])
  redirect "/memos/#{lastest_memo_id(fetch_memos)}"
end

get '/memos/:id' do
  @memo = find_memo(params[:id])

  @page_title = 'show memo'

  erb :show
end

get '/memos/:id/edit' do
  @memo = find_memo(params[:id])

  @page_title = 'Edit memo'

  erb :edit
end

patch '/memos/:id' do
  connection.exec_params('UPDATE memos SET title = $1, body = $2 WHERE id = $3', [params[:title], params[:body], params[:id]])
  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  connection.exec_params('DELETE FROM memos WHERE id = $1', [params[:id]])
  redirect '/memos'
end
