class TweetsController < ApplicationController

  # HTTP Verb - Route - Action - Used For

  # GET - /tweets - index action - index page to display all tweets
  get '/tweets' do
    if Helpers.logged_in?(session)
      @tweets = Tweet.all
      erb :'/tweets/tweets'
    else
      flash[:message] = "You must be logged in to tweets."
      redirect :"/login"
    end
  end

  # GET - /tweets/new - new action - displays create tweet form
  get '/tweets/new' do
    if Helpers.logged_in?(session)
      erb :'/tweets/create_tweet'
    else
      flash[:message] = "You must be logged in to add a tweet."
      redirect :"/login"
    end
  end

  # POST - /tweets - create action - creates one tweet
  post '/tweets' do
    #binding.pry
    if Helpers.logged_in?(session)
      if params[:content].empty?
        flash[:message] = "Your tweet cannot be left blank! "
        redirect :"/tweets/new"
      else
        tweet = Tweet.create(params)
        tweet.user_id = session[:user_id]
        tweet.save

        flash[:message] = "Successfully added your tweet! "
        redirect :"/tweets/#{tweet.id}"
      end
    else
      flash[:message] = "You must be logged in to add a tweet."
      redirect :"/login"
    end
  end

  # GET - /tweets/:id - show action - displays one tweet based on tweet id in the url
  get '/tweets/:id' do
    if Helpers.logged_in?(session)
      @tweet = Tweet.find_by_id(params[:id])
      erb :'/tweets/show_tweet'
    else
      flash[:message] = "You must be logged in to view a tweet."
      redirect :"/login"
    end
  end

  # GET - /tweets/:id/edit - edit action - displays one tweet based on tweet id in the url for editing
  get '/tweets/:id/edit' do
    if Helpers.logged_in?(session)
      @tweet = Tweet.find_by_id(params[:id])
      if @tweet && Helpers.current_user(session).id == @tweet.user_id
        erb :'/tweets/edit_tweet'
      else
        flash[:message] = "You must be the tweet owner to edit a tweet."
        redirect :"/tweets"
      end
    else
      flash[:message] = "You must be logged in to edit a tweet."
      redirect :"/login"
    end
  end

  # PATCH - /tweets/:id - edit action - edits an existing tweet bsed on tweet id in the url
  patch '/tweets/:id' do
    #binding.pry
    if Helpers.logged_in?(session)
      @tweet = Tweet.find_by_id(params[:id])
      if params[:content].empty?
        flash[:message] = "Your tweet cannot be left blank! "
        redirect :"/tweets/#{@tweet.id}/edit"
      else
        if params[:content] == @tweet.content
          flash[:message] = "There's been no changes made to the tweet!"
          redirect :"/tweets/#{@tweet.id}/edit"
        elsif Helpers.current_user(session) == @tweet.user
          @tweet.content = params[:content]
          @tweet.save
          flash[:message] = "Successfully edited Tweet!"
          redirect :"/tweets/#{@tweet.id}"
        else
          flash[:message] = "You must be the tweet owner to edit this."
          redirect :"/tweets"
        end
      end
    else
      flash[:message] = "You must be logged in to edit a tweet."
      redirect :"/login"
    end
  end

  # DELETE - /tweets/:id/delete - delete action
  delete '/tweets/:id/delete' do
    if Helpers.logged_in?(session)
      @tweet = Tweet.find_by_id(params[:id])
      if @tweet && Helpers.current_user(session).id == @tweet.user_id
        @tweet.delete
        flash[:message] = "You've successfully deleted Tweet id #{params[:id]}!"
        redirect :"/tweets"
      else
        flash[:message] = "You must be the tweet owner to delete this."
        redirect :"/tweets"
      end
    else
      flash[:message] = "You must be logged in to delete a tweet."
      redirect :"/users/login"
    end
  end

end
