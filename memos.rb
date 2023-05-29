require 'sinatra'
require 'sinatra/reloader'

get '/' do
  @title = "Top | メモアプリ"
  erb :index
end
