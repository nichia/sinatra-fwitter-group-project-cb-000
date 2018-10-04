class UsersController < ApplicationController

  # GET - /users - index action - renders an index for listing users
  get '/users' do
    if Helpers.logged_in?(session)
      @users = User.all
      erb :'/users/index'
    else
      erb :'/users/login'
    end
  end

  # GET - /login - renders a form for logging in
  get '/login' do
    if Helpers.logged_in?(session)
      redirect :"/tweets"
    else
      erb :'/users/login'
    end
  end

  # POST - /login - find the user by username and check that the password matches up. Fill in the session data
  post '/login' do
    if params[:username].empty? || params[:password].empty?
      flash[:message] = "Username and password cannot be left blank."
      erb :'/users/login'
    else
      user = User.find_by(username: params[:username])
      if user && user.authenticate(params[:password])
        flash[:message] = "You've successfully created an account with Fwitter."
        session[:user_id] = user.id
        redirect :"/tweets"
      else
        session.clear
        flash[:message] = "Account not found, please try again."
        erb :'/users/login'
      end
    end
  end

  # GET - /signup - renders a form to create a new user. The form includes fields for username, email and password
  get '/signup' do
    if Helpers.logged_in?(session)
      redirect :"/tweets"
    else
      erb :'/users/create_user'
    end
  end

  # POST - /signup - create a new instance of user class with a username, email and password. Fill in the session data
  post '/signup' do
    if params[:username].empty? || params[:email].empty? || params[:password].empty?
      flash[:message] = "Username, email and password can not be left blank."
      redirect :"/signup"
    elsif User.find_by(username: params[:username])
      flash[:message] = "Username already taken, please use another username."
      redirect :"/signup"
    elsif User.find_by(email: params[:email])
      flash[:message] = "An account already exists with this email, please use another email."
      redirect :"/signup"
    else
      user = User.new
      user.username = params[:username]
      user.email = params[:email]
      user.password = params[:password]
      user.save

      session[:user_id] = user.id
      redirect :"/tweets"
    end
  end

  # GET - /logout - clears the session data and redirects to the homepage
  get '/logout' do
    if Helpers.logged_in?(session)
      session.clear
      flash[:message] = "Successfully logged out."
      redirect :"/login"
    else
      redirect :"/"
    end
  end

  # GET - /users/:slug - Read action to list this user's tweets
  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    if @user
      erb :'/users/show'
    else
      erb :'not_found'
    end
  end


end
