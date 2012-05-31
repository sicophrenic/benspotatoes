class PagesController < ApplicationController
  def home
  end

  def about
  end

  def todo
  end
  
  def search
    if !user_signed_in?
      redirect_to new_user_session_path
    end
  end
end
