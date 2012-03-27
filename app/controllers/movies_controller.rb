class MoviesController < ApplicationController  
  def index
    if params[:nuke]
      session.clear
    end
    
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings] || session[:ratings] || {}
    if params[:ratings] != session[:ratings] and @selected_ratings != {}
      session[:ratings] = params[:ratings]
      @restore = true
    end
    
    @all_locations = Movie.all_locations
    @selected_locations = params[:locations] || session[:locations] || {}
    if params[:locations] != session[:locations] and @selected_locations != {}
      session[:locations] = params[:locations]
      @restore = true
    end
    
    @all_qualities = Movie.all_qualities
    @selected_qualities = params[:qualities] || session[:qualities] || {}
    if params[:qualities] != session[:qualities] and @selected_qualities != {}
      session[:qualities] = params[:qualities]
      @restore = true
    end
    
    if @restore
      redirect_to movies_path(:ratings => @selected_ratings,
                              :locations => @selected_locations,
                              :qualities => @selected_qualities)
    end
    
    @movies = Movie.find(:all, :conditions => ["rating IN (?) AND
                                                location IN (?) AND
                                                quality IN (?)",  @selected_ratings.keys,
                                                                  @selected_locations.keys,
                                                                  @selected_qualities.keys])
  end

  def show
    @movie = Movie.find(params[:id])
  end

  def new
    @all_ratings = Movie.all_ratings
    @all_qualities = Movie.all_qualities
    @all_locations = Movie.all_locations
  end

  def edit
    @movie = Movie.find(params[:id])
    @all_qualities = Movie.all_qualities
  end

  def create
    params[:movie][:quality] = params[:quality].keys.join(' ')
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def update
    @movie = Movie.find(params[:id])
    params[:movie][:quality] = params[:quality].keys.join(' ')
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end
  
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "#{@movie.title} was successfully deleted."
    redirect_to movies_path
  end
end
