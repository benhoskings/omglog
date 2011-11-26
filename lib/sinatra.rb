require 'sinatra'
require 'haml'
require 'coffee-script'
require 'sinatra/reloader'

require File.expand_path('../zomglog', __FILE__)

get '/' do
  Omglog.new(".").to_html
end
get '/goodfilms' do
  Omglog.new("~/src/goodfilms").to_html
end
