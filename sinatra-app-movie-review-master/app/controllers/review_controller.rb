class ReviewController < ApplicationController

  # Create
  get '/reviews/new' do # takes you to the create a movie review page
    if is_logged_in?
      erb :'reviews/new'
    else
      flash[:message] = "Looks like you weren't logged in yet. Please log in below."
      redirect to '/login'
    end
  end
  
  post '/reviews' do
      if params[:title] == "" || params[:genre] == "" || params[:content] == "" || params[:rating] == "" # must have title, genre, content, & rating
        flash[:message] = "Reviews must have a title, genre, content and rating. Please try again."
        redirect to '/reviews/new'
      else
        critic = current_critic
        @review = Review.create(
          :title => params[:title],
          :genre => params[:genre],
          :content => params[:content],
          :rating => params[:rating],
          :critic_id => critic.id)
        redirect to "/reviews/#{@review.id}"
      end
    end  
  
    # Read
    get '/reviews' do
      if is_logged_in?
        @reviews = current_critic.reviews
        @other_reviews = Review.where("critic_id != ?", current_critic.id)
        erb :'reviews/index'
      else
        flash[:message] = "Looks like you weren't logged in yet. Please log in below."
        redirect to '/login'
      end
    end
  
    get '/reviews/:id' do
      if is_logged_in?
        @review = Review.find_by_id(params[:id])
        if @review.critic_id == session[:critic_id]
          erb :'reviews/show'
        elsif @review.critic_id != session[:critic_id]
          redirect '/reviews'
        end
      else
        flash[:message] = "Looks like you weren't logged in yet. Please log in below."
        redirect to '/reviews'
      end
    end
  
    # Update
    get '/reviews/:id/edit' do
      if is_logged_in?
        @review = Review.find_by_id(params[:id])
        if @review.critic_id == session[:critic_id]
          erb :'reviews/edit'
        else
          flash[:message] = "Sorry, you may only edit your review."
          redirect to '/reviews'
          end
      else
        flash[:message] = "Looks like you weren't logged in yet. Please log in below."
        redirect to '/login'
      end
    end  
  
    patch '/reviews/:id' do
      if params[:title] == "" || params[:genre] == "" || params[:content] == "" || params[:rating] == ""
        flash[:message] = "Reviews must have a title, genre, content and rating. Please try again."
        redirect to "/reviews/#{params[:id]}/edit"
      else
        @review = Review.find_by_id(params[:id])
        @review.title = params[:title]
        @review.genre = params[:genre]
        @review.content = params[:content]
        @review.rating = params[:rating]
        @review.critic_id = current_critic.id
        @review.save
        flash[:messsage] = "Your review has been updated!"
        redirect to "/reviews/#{@review.id}"
      end
    end
  
    # Delete
    delete '/reviews/:id/delete' do
      if is_logged_in?
        @review = Review.find_by_id(params[:id])
        if @review.critic_id == session[:critic_id]
          @review.delete
          flash[:message] = "The review was deleted."
          redirect to '/reviews'
        end
      else
        flash[:message] = "Looks like you weren't logged in yet. Please log in below."
        redirect to '/login'
      end
    end

end
