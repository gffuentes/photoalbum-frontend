require 'sinatra'

get "/" do
  erb :home
end

get "/gallery/:name" do
  erb :gallery
end
