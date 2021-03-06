class MoviesController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @ratings_hash = {}
    Movie.all_ratings.each do |rating|
      @ratings_hash[rating] = "1"
    end
    
    @locations_hash = {}
    Movie.all_locations.each do |location|
      @locations_hash[location] = "1"
    end
    
    @qualities_hash = {}
    Movie.all_qualities.each do |quality|
      @qualities_hash[quality] = "1"
    end
    
    if params[:nuke]
      if Rails.env.development?
        puts "SESSION NUKE"
      end
      reset_movies
      # flash[:notice] = "Session reset."
      return
    end
    
    checkbox_params("ratings")
    checkbox_params("locations")
    checkbox_params("qualities")
     
    search_params("title")
    search_params("director")
    
    year_params("start")
    year_params("end")
    if !valid_years?
      redirect_to search_path
      return
    end

    page_params

    sort_params
    
    if @restore
      puts "RESTORE"
      # @sort = session[:sort]
      # @viewby = session[:viewby]
      handle_flash
      redirect_to movies_path(:ratings => @selected_ratings,
                              :locations => @selected_locations,
                              :qualities => @selected_qualities,
                              # :sort => @sort,
                              # :viewby => @viewby,
                              :title_search => @title_search,
                              :director_search => @director_search,
                              :start => @start_year,
                              :end => @end_year,
                              :per_page => @per_page)
      return
    end
    
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
                                :order => "#{@sort} #{@viewby}")
      @count = @movies.count
    if @paginate
      @movies = @movies.paginate(page: params[:page], per_page: @per_page)
    end
    
    case @viewby
    when 'ASC'
      @viewby = 'DESC'
    when 'DESC'
      @viewby = 'ASC'
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
    if !current_user.admin?
      flash[:error] = "Hey, you can't do that! You can't create movies unless you're Ben, you silly goose!"
      redirect_to movies_path
      return
    end
    if params[:generate]
      @result = generate_movie(params[:movie][:title])
      flash[:notice] = "#{@result.title} was successfully created. Make sure to verify the information on this page (especially Location and Quality!)"
      redirect_to edit_movie_path(@result)
    else
      @movie = Movie.new(params[:movie])
      if @movie.save
        flash[:success] = "#{@movie.title} was successfully created."
        redirect_to movie_path(@movie)
      else
        flash[:error] = "#{@movie.title} was not successfully created: #{@movie.errors.full_messages.first}."
        redirect_to new_movie_path
      end
    end
  end

  def update
    if !current_user.admin?
      flash[:error] = "Hey, you can't do that! You can't edit movies unless you're Ben, you silly goose!"
      redirect_to movies_path
      return
    end
    @movie = Movie.find(params[:id])
    if @movie.update_attributes(params[:movie])
      flash[:success] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    else
      flash[:error] = "#{@movie.title} was not successfully updated: #{@movie.errors.full_messages.first}."
      redirect_to edit_movie_path(@movie)
    end
  end
  
  def destroy
    if !current_user.admin?
      flash[:error] = "Hey, you can't do that! You can't delete movies unless you're Ben, you silly goose!"
      redirect_to movies_path
      return
    end
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:success] = "#{@movie.title} was successfully deleted."
    redirect_to movies_path
  end
  
  def addqueue
    @toadd = Movie.find(params[:toadd])
    @queue = current_user.queue.split('|')
    if @queue.count == 5
      flash[:error] = "You can't have more than five potatoes lined up! You're going to have to get rid of a few first!"
    elsif @queue.index(@toadd.id.to_s) != nil
      flash[:error] = "That potato is already in your queue! Maybe you should take care of that one first!"
    else
      flash[:success] = "Congratulations! You have successfuly added a potato to your lineup!"
      current_user.queue += "#{@toadd.id}|"
      current_user.save
    end
    redirect_to movie_path(@toadd)
  end
  
  def removequeue
    @toremove= params[:toremove]
    if @toremove == "empty"
      current_user.queue = ""
    else
      if current_user.queue.split('|').index(@toremove) != nil
        current_user.queue = remove_item(current_user.queue, @toremove)
        current_user.queue += "|"
      else
        flash[:error] = "Something's not right... That potato wasn't in your lineup!"
      end
    end
    current_user.save
    redirect_to user_queue_path
  end
  
  protected
    def checkbox_params(param_type)
      case param_type
      when 'ratings'
        @selected_ratings = params[:ratings] || session[:ratings] || @ratings_hash
        if params[:ratings]
          session[:ratings] = params[:ratings]
        end
        if !params[:ratings] and session[:ratings]
          session[:ratings] = params[:ratings]
          @restore = true
          if Rails.env.development?
            puts "RATINGS RESTORE"
          end
        end
      when 'locations'
        @selected_locations = params[:locations] || session[:locations] || @locations_hash
        if params[:locations]
          session[:locations] = params[:locations]
        end
        if !params[:locations] and session[:locations]
          session[:locations] = params[:locations]
          @restore = true
          if Rails.env.development?
            puts "LOCATIONS RESTORE"
          end
        end
      when 'qualities'
        @selected_qualities = params[:qualities] || session[:qualities] || @qualities_hash
        if params[:qualities]
          session[:qualities] = params[:qualities]
        end
        if !params[:qualities] and session[:qualities]
          session[:qualities] = params[:qualities]
          @restore = true
          if Rails.env.development?
            puts "QUALITIES RESTORE"
          end
        end
      end
    end

    def search_params(param_type)
      case param_type
      when 'title'
        @title_search = params[:title_search] || session[:title_search] || ""
        if params[:title_search] != ""
          session[:title_search] = params[:title_search]
        end
        if !params[:title_search] and session[:title_search]
          session[:title_search] = params[:title_search]
          @restore = true
          if Rails.env.development?
            puts "TITLESEARCH RESTORE"
          end
        end
      when 'director'
        @director_search = params[:director_search] || session[:director_search] || ""
        if params[:director_search] != ""
          session[:director_search] = params[:director_search]
        end
        if !params[:director_search] and session[:director_search]
          session[:director_search] = params[:director_search]
          @restore = true
          if Rails.env.development?
            puts "DIRECTORSEARCH RESTORE"
          end
        end
      end
      if @title_search != nil
        @title_search = @title_search.gsub(/[^a-zA-Z0-9]/,'')
      end
      if @director_search != nil
        @director_search = @director_search.gsub(/[^a-zA-Z0-9]/,'')
      end
    end

    def year_params(param_type)
      case param_type
      when 'start'
        @start_year = params[:start] || session[:start] || {:year => Movie.earliest_movie.year.to_i}
        if !params[:start] and session[:start]
          session[:start] = params[:start]
          @restore = true
          if Rails.env.development?
            puts "STARTYEAR RESTORE"
          end
        end
        @start_year[:year] = @start_year[:year].to_s.gsub(/[^0-9]/,'').to_i
        @start_search = Date.new(@start_year[:year].to_i,1,1)
      when 'end'
        @end_year = params[:end] || session[:end] || {:year => Date.today.year+1}
        if !params[:end] and session[:end]
          session[:end] = params[:end]
          @restore = true
          if Rails.env.development?
            puts "ENDYEAR RESTORE"
          end
        end
        @end_year[:year] = @end_year[:year].to_s.gsub(/[^0-9]/,'').to_i
        @end_search = Date.new(@end_year[:year].to_i,12,31)
      end
    end
    
    def valid_years?
      if params[:start] && params[:end] && params[:start][:year] > params[:end][:year]
        params[:start] = {:year => Movie.earliest_movie.year}
        params[:end] = {:year => Date.today.year+1}
        flash[:error] = "Potatoes can't be harvested before they've been made! (Your start search year was later than your end search year!)"
        return false
      else
        session[:start] = params[:start]
        session[:end] = params[:end]
        return true
      end
    end

    def page_params
      @per_page = params[:per_page] || session[:per_page] || 20
      @paginate = true
      if @per_page == "All"
        @paginate = false
      end
      if params[:per_page]
        session[:per_page] = params[:per_page]
      end
      if !params[:per_page] and session[:per_page]
        session[:per_page] = params[:per_page]
        @restore = true
        if Rails.env.development?
          puts "PERPAGE RESTORE"
        end
      end
    end

    def sort_params
      @sort = params[:sort] || 'title'
      @viewby = params[:viewby] || 'ASC'
      case @sort
      when 'title'
        @title_header = 'hilite'
      when 'release_date'
        @release_header = 'hilite'
      end
      if @sort != session[:sort]
        @viewby = 'ASC'
      end
      session[:sort] = @sort
      # case @viewby
      # when 'ASC'
      #   @viewby = 'DESC'
      #   @orderby = 'ASC'
      # when 'DESC'
      #   @viewby = 'ASC'
      #   @orderby = 'DESC'
      # end
      # if params[:sort] != session[:sort] && session[:sort]
      #   @viewby = 'DESC'
      #   @orderby = 'ASC'
      # end
      # if @sort != session[:sort] && @sort
      #   session[:sort] = @sort
      # end
      # if @viewby != session[:viewby] && @viewby
      #   session[:viewby] = @viewby
      # end
    end
    
    def handle_flash
      flash.each do |type, message|
        flash[type] = message
      end
    end
    
    def reset_movies
      @selected_ratings = @ratings_hash
      @selected_locations = @locations_hash
      @selected_qualities = @qualities_hash
      session[:ratings] = @selected_ratings
      session[:locations] = @selected_locations
      session[:qualities] = @selected_qualities
      session[:title_search] = ""
      session[:director_search] = ""
      session[:start] = {:year => Movie.earliest_movie.year.to_i}
      session[:end] = {:year => Date.today.year+1}
      session[:per_page] = 20
      redirect_to movies_path(:ratings => @selected_ratings,
                              :locations => @selected_locations,
                              :qualities => @selected_qualities,
                              :title_search => "",
                              :director_search => "",
                              :start => {:year => Movie.earliest_movie.year.to_i},
                              :end => {:year => Date.today.year+1},
                              :per_page => 20)
    end
    
    def remove_item(queue, movie_id)
      q = queue.split('|')
      index = q.index(movie_id.to_s)
      q.delete_at(index)
      nq = q.join('|')
    end
    
    def generate_movie(title)
      imdb = Imdb::Search.new(title).movies().first
      title = imdb.title.gsub(/\s?\(.*\)/,'')
      director = imdb.director[0]
      imdb.mpaa_rating.match(/Rated\s?(.{1,5})\s?/)
      rating = $1
      location = "F"
      quality = "720p"
      release = imdb.release_date.gsub(/\s?\(.*\)/,'').gsub(' ','-')
      poster = imdb.poster
      result = Movie.create!(:title => title, :director => director,
                                              :rating => rating,
                                              :location => location,
                                              :quality => quality,
                                              :release_date => release,
                                              :poster => poster)
    end
end
