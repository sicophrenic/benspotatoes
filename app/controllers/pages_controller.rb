class PagesController < ApplicationController
  def home
  end

  def about
  end
  
  def search
    if !user_signed_in?
      redirect_to new_user_session_path
    end
  end
  
  def currentuser
    @queue = {}
    current_user.queue.split('|').each do |id|
      if id != ""
        @item = Movie.find(id)
        @queue[@item] = @item.poster
        # @queue[@movie_item] = "http://ia.media-imdb.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@.jpg"
      end
    end
  end
end
