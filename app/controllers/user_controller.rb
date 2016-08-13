class UserController < ApplicationController

  ## CREATE USER ###
  get '/signup' do
    if !!session[:user_id]
      redirect '/tweets'
    else
      erb :'users/create_user'
    end
  end

  post '/signup' do
    if !params[:username].empty? && !params[:password].empty? && !params[:email].empty?
      user = User.create(username: params[:username], email: params[:email], password: params[:password])
      session[:user_id] = user.id
      redirect "/#{user.slug}/tweets"
    else
      redirect "/signup"
    end
  end

  ### LOGIN USER ###
  get '/login' do
    if !!session[:user_id]
      user = User.find(session[:user_id])
      redirect "/#{user.slug}/tweets"
    else
      erb :'users/login'
    end
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/#{user.slug}/tweets"
    else
      redirect "/login"
    end
  end

  ### LOGOUT USER ###
  get '/logout' do
    if !!session[:user_id]
      session.clear
      redirect "/login"
    else 
      redirect "/"
    end
  end

end
