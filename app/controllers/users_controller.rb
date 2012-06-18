class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @user = current_user
    @user_queues = {}
    User.all.each do |user|
      @user_queues[user] = generate_queue(user)
    end
  end

  def me
    @user = current_user
    if !user_signed_in?
      redirect_to new_user_session_path
      return
    end
    @queue = generate_queue(current_user)
  end
  
  protected
    def generate_queue(user)
      @movies = []
      user.queue.split('|').each do |id|
        if id != ""
          @movies << Movie.find(id)
        end
      end
      @movies
    end
end
