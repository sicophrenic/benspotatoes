class MoviesController < ApplicationController  
  def index    
    if params[:nuke]
      session.clear
      # flash[:notice] = "Session reset."
      redirect_to movies_path
      return
    end
    
    @ratings_hash = {}
    Movie.all_ratings.each do |rating|
      @ratings_hash[rating] = "1"
    end
    @selected_ratings = params[:ratings] || session[:ratings] || @ratings_hash
    if params[:ratings] != session[:ratings] and @selected_ratings != @ratings_hash
      session[:ratings] = params[:ratings]
      @restore = true
    end
    
    @locations_hash = {}
    Movie.all_locations.each do |location|
      @locations_hash[location] = "1"
    end
    @selected_locations = params[:locations] || session[:locations] || @locations_hash
    if params[:locations] != session[:locations] and @selected_locations != @locations_hash
      session[:locations] = params[:locations]
      @restore = true
    end
    
    @qualities_hash = {}
    Movie.all_qualities.each do |quality|
      @qualities_hash[quality] = "1"
    end
    @selected_qualities = params[:qualities] || session[:qualities] || @qualities_hash
    if params[:qualities] != session[:qualities] and @selected_qualities != @qualities_hash
      session[:qualities] = params[:qualities]
      @restore = true
    end

    @title_search = params[:title_search] || session[:title_search] || ''
    if params[:title_search] != session[:title_search] && params[:title_search] != ''
      session[:title_search] = params[:title_search]
      @restore = true
    end
    
    @director_search = params[:director_search] || session[:director_search] || ''
    if params[:director_search] != session[:director_search] && params[:director_search] != ''
      session[:director_search] = params[:director_search]
      @restore = true
    end
    
    @start_year = params[:start] || session[:start] || {:year => Movie.earliest_movie.year}
    if params[:start] != session[:start] && params[:start] != {:year => Movie.earliest_movie.year}
      session[:start] = params[:start]
      @restore = true
    end
    @start_search = Date.new(@start_year[:year].to_i,1,1)
    
    @end_year = params[:end] || session[:end] || {:year => Date.today.year+1}
    if params[:end] != session[:end] && params[:end] != {:year => Date.today.year+1}
      session[:end] = params[:end]
      @restore = true
    end
    @end_search = Date.new(@end_year[:year].to_i,12,31)
    
    if params[:start] && params[:end] && params[:start][:year] > params[:end][:year]
      params[:start] = session[:start] = {:year => Movie.earliest_movie.year}
      params[:end] = session[:end] = {:year => Date.today.year+1}
      flash[:error] = "Potatoes can't be harvested before they've been made! (Your start search year was later than your end search year!)"
      puts params
      redirect_to search_path
      return
    end
    
    @per_page = params[:per_page] || session[:per_page] || 20
    @paginate = true
    if @per_page == "All"
      @paginate = false
    end
    if params[:per_page] != session[:per_page]
      session[:per_page] = params[:per_page]
      @restore = true
    end
    
    @sort = params[:sort] || session[:sort] || 'title'
    viewby = 'ASC'
    case @sort
    when 'title'
      orderby = :title
      @title_header = 'hilite'
      if params[:sort] == session[:sort] && params[:sort]
        viewby = 'DESC'
      else
        session[:sort] = params[:sort]
        viewby = 'ASC'
      end
    when 'release_date'
      orderby = :release_date
      @release_header = 'hilite'
      if params[:sort] == session[:sort] && params[:sort]
        viewby = 'DESC'
      else
        session[:sort] = params[:sort]
        viewby = 'ASC'
      end
    end
    
    if @restore
      redirect_to movies_path(:ratings => @selected_ratings,
                              :locations => @selected_locations,
                              :qualities => @selected_qualities,
                              :sort => @sort,
                              :title_search => @title_search,
                              :director_search => @director_search,
                              :start => @start_year,
                              :end => @end_year,
                              :per_page => @per_page)
      return
    end
    
    if @selected_ratings.count != Movie.all_ratings.count ||
        @selected_locations.count != Movie.all_locations.count ||
        @selected_qualities.count != Movie.all_qualities.count ||
        @title_search || @director_search ||
        @start_year || @end_year
      @check_count = true
    end
    
    if @paginate
      # flash.now[:notice] = %Q(title_search for "#{@title_search}")
      @movies = Movie.find(:all,  :conditions => ["rating IN (?) AND
                                                  location IN (?) AND
                                                  quality IN (?) AND
                                                  lower(title) LIKE (?) AND
                                                  lower(director) LIKE (?) AND
                                                  release_date >= (?) AND
                                                  release_date <= (?)",  @selected_ratings.keys,
                                                                    @selected_locations.keys,
                                                                    @selected_qualities.keys,
                                                                    "%#{@title_search.downcase}%",
                                                                    "%#{@director_search.downcase}%",
                                                                    @start_search,
                                                                    @end_search],
                                  :order => "#{orderby} #{viewby}")
      @count = @movies.count
      @movies = @movies.paginate(page: params[:page], per_page: @per_page)
    else
      # flash.now[:notice] = %Q(title_search for "#{@title_search}")
      @movies = Movie.find(:all,  :conditions => ["rating IN (?) AND
                                                  location IN (?) AND
                                                  quality IN (?) AND
                                                  lower(title) LIKE (?) AND
                                                  lower(director) LIKE (?) AND
                                                  release_date >= (?) AND
                                                  release_date <= (?)",  @selected_ratings.keys,
                                                                    @selected_locations.keys,
                                                                    @selected_qualities.keys,
                                                                    "%#{@title_search.downcase}%",
                                                                    "%#{@director_search.downcase}%",
                                                                    @start_search,
                                                                    @end_search],
                                  :order => "#{orderby} #{viewby}")
      @count = Movie.count
    end
  end

  def show
    @movie = Movie.find(params[:id])
  end

  def new
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def create
    @movie = Movie.new(params[:movie])
    if @movie.save
      flash[:success] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    else
      flash[:error] = "#{@movie.title} was not successfully created: #{@movie.errors.full_messages.first}."
      redirect_to new_movie_path
    end
  end

  def update
    @movie = Movie.find(params[:id])
    if @movie.update_attributes(params[:movie])
      flash[:success] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    else
      flash[:error] = "#{@movie.title} was not successfully updated: #{@movie.errors.full_messages.first}."
      redirect_to movie_path(@movie)
    end
  end
  
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:success] = "#{@movie.title} was successfully deleted."
    redirect_to movies_path
  end
end
