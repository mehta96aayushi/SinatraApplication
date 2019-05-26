# require 'dm-core'
# require 'dm-migrations'
require './main'
require './comment'

DataMapper.setup(:default, ENV['DATABASE_URL']|| "sqlite3://#{Dir.pwd}/development.db")
configure do
  enable :sessions
  set :username, "aayushi"
  set :password, "aayushi@123"
end

class Student
  include DataMapper::Resource
  property :id, Serial
  property :firstname, String
  property :lastname, String
  property :birthday, Date
  property :address, String
  property :studentid, String

  def birthday=date
    super Date.strptime(date, '%m/%d/%Y')
  end
end

DataMapper.finalize
DataMapper.auto_upgrade!

get '/students' do
  @students = Student.all
  if session[:admin] == true
    erb :studentInfo, :layout => :logoutLayout
  else
    erb :studentInfo, :layout => :layout
  end
end

get '/students/new' do
  redirect to('/logout') unless session[:admin]
  student = Student.new
  erb :createStudent, :layout => :logoutLayout
end

get '/login' do
  erb :loginPage
end

post '/login' do
  if params[:username] == settings.username && params[:password] == settings.password
      session[:admin] = true
      erb :loginMsg, :layout => :logoutLayout
  else
    erb :loginPage
  end
end

get '/logout' do
session.clear
session[:admin] = false
erb :loginPage, :layout => :layout

end

#Route for the new student form
get '/students/new' do
  redirect to('/logout') unless session[:admin]
  @student = Student.new
  erb :createStudent
end

#Shows a single student
get '/students/:id' do
  @student = Student.get(params[:id])
  if session[:admin] == true
    erb :studentDetails, :layout => :logoutLayout
  else
    erb :studentDetails, :layout => :layout
  end
end

#Route for the form to edit a single student
get '/students/:id/edit' do
  redirect to('/logout') unless session[:admin]
  @student = Student.get(params[:id])
  if session[:admin] == true
    erb :editStudent, :layout => :logoutLayout
  else
    erb :editStudent, :layout => :layout
  end
end

#Creates new student
post '/students' do
  redirect to('/logout') unless session[:admin]
  @student = Student.create(params[:student])
  redirect to('/students')
end

#Edits a single student
put '/students/:id' do
  redirect to('/logout') unless session[:admin]
  @student = Student.get(params[:id])
  @student.update(params[:student])
  redirect to("/students/#{@student.id}")
end

#Deletes a single student
delete '/students/:id' do
  redirect to('/logout') unless session[:admin]
  Student.get(params[:id]).destroy
  redirect to('/students')
end
