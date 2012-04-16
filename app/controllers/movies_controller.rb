class MoviesController < ApplicationController  
  def index
    if params[:nuke]
      session.clear
        redirect_to movies_path()
    end
    
    @all_ratings = Movie.all_ratings
    @ratings_hash = {}
    @all_ratings.each do |rating|
      @ratings_hash[rating] = "1"
    end
    @selected_ratings = params[:ratings] || session[:ratings] || @ratings_hash
    if params[:ratings] != session[:ratings] and @selected_ratings != @ratings_hash
      session[:ratings] = params[:ratings]
      @restore = true
    end
    
    @all_locations = Movie.all_locations
    @locations_hash = {}
    @all_locations.each do |location|
      @locations_hash[location] = "1"
    end
    @selected_locations = params[:locations] || session[:locations] || @locations_hash
    if params[:locations] != session[:locations] and @selected_locations != @locations_hash
      session[:locations] = params[:locations]
      @restore = true
    end
    
    @all_qualities = Movie.all_qualities
    @qualities_hash = {}
    @all_qualities.each do |quality|
      @qualities_hash[quality] = "1"
    end
    @selected_qualities = params[:qualities] || session[:qualities] || @qualities_hash
    if params[:qualities] != session[:qualities] and @selected_qualities != @qualities_hash
      session[:qualities] = params[:qualities]
      @restore = true
    end

    @search = params[:search] || session[:search] || ''
    if params[:search] != session[:search] && params[:search] != ''
      session[:search] = params[:search]
      @restore = true
    end
    
    @sort = params[:sort] || session[:sort]
    case @sort
    when 'title'
      orderby = :title
      @title_header = 'hilite'
    when 'release_date'
      orderby = :release_date
      @release_header = 'hilite'
    end
    
    if @restore
      redirect_to movies_path(:ratings => @selected_ratings,
                              :locations => @selected_locations,
                              :qualities => @selected_qualities,
                              :sort => @sort,
                              :search => @search)
    end
    
    if @search != ''
      @movies = Movie.find(:all,  :conditions => ["rating IN (?) AND
                                                  location IN (?) AND
                                                  quality IN (?) AND
                                                  title LIKE (?)",  @selected_ratings.keys,
                                                                    @selected_locations.keys,
                                                                    @selected_qualities.keys,
                                                                    "%#{@search}%"],
                                  :order => orderby)
    else
      @movies = Movie.find(:all,  :conditions => ["rating IN (?) AND
                                                  location IN (?) AND
                                                  quality IN (?)",  @selected_ratings.keys,
                                                                    @selected_locations.keys,
                                                                    @selected_qualities.keys],
                                  :order => orderby)
    end
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
    @all_ratings = Movie.all_ratings
    @all_qualities = Movie.all_qualities
    @all_locations = Movie.all_locations
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
