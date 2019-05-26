require 'sinatra'
require 'sass'
require './student'
require './comment'
require 'sinatra/reloader' if development?

#enable :sessions
configure :production do
    DataMapper.setup(:default, ENV['DATABASE_URL']|| "sqlite3://#{Dir.pwd}/development.db") #connecting to db
end

configure :development do
    DataMapper.setup(:default, ENV['DATABASE_URL']|| "sqlite3://#{Dir.pwd}/development.db") #connecting to db
end

get('/style.scss'){ scss :style }

get '/' do
  	if session[:admin] == true
		erb :homePage, :layout => :logoutLayout
	else
		erb :homePage
	end
end

get '/about' do
 	@title = "All About This Website"
  	if session[:admin] == true
		erb :about, :layout => :logoutLayout
	else
		erb :about
	end
end

get '/contact' do
	if session[:admin] == true
		erb :contactInfo, :layout => :logoutLayout
	else
		erb :contactInfo
	end
end

get '/video' do
	if session[:admin] == true
		erb :video, :layout => :logoutLayout
	else
		erb :video
	end
end