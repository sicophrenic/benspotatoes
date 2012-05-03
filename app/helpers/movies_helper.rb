module MoviesHelper
  def search_by(movies, title = nil, director = nil, ratings = nil, locations = nil, qualities = nil)
    if title
      movies.keep_if { |movie| movie.title.downcase =~ /#{title.downcase}/ }
    end
    if director
      movies.keep_if { |movie| movie.director.downcase =~ /#{director.downcase}/ }
    end
    if ratings
      ratings.each do |rating|
        movies.keep_if { |movie| movie.rating == rating }
      end
    end
    if locations
      locations.each do |location|
        movies.keep_if { |movie| movie.location == location }
      end
    end
    if qualities
      qualities.each do |quality|
        movies.keep_if { |quality| movie.quality == quality }
      end
    end
  end
end
