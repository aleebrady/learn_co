require './config/environment'
require 'sinatra/flash'

class ApplicationController < Sinatra::Base

  # enable sessions
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'movies_are_awesome'
    register Sinatra::Flash
  end

  # Homepage
  get '/' do
    erb :index
  end
  
  def is_logged_in?
    !!current_user
  end

  def current_critic
    @current_critic ||= Critic.find_by(id: session[:critic_id])
  end

end
