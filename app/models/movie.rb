# == Schema Information
#
# Table name: movies
#
#  id           :integer         not null, primary key
#  title        :string(255)
#  director     :string(255)
#  rating       :string(255)
#  location     :string(255)
#  quality      :string(255)
#  release_date :datetime
#  created_at   :datetime
#  updated_at   :datetime
#

class Movie < ActiveRecord::Base
  validates :title, :presence   => true,
                    :length     => { :maximum => 50 }
  validates :director, :presence => true
  validates :rating,  :presence => true,
                      :length   => { :maximum => 5 },
                      :inclusion => { :in => %w(G PG PG-13 M R) }
  validates :location,  :presence => true,
                        :length   => { :maximum => 1 },
                        :inclusion => { :in => %w(E F G H K) }
  validates :quality, :presence => true,
                      :inclusion => { :in => %w(480p 720p 1080p) }
  validates :release_date,  :presence => true,
                            :if => :invalid_movie_date?

  def self.all_ratings
    %w(G PG PG-13 M R)
  end
  
  def self.all_qualities
    %w(480p 720p 1080p)
  end
  
  def self.all_locations
    %w(E F G H K)
  end
  
  def self.earliest_movie
    if Movie.find(:all, :order => :release_date).first
      Movie.find(:all, :order => :release_date).first.release_date
    else
      Date.new(1900)
    end
  end
  
  protected
    def invalid_movie_date?
      errors.add(:release_date, ("is not a valid date between the years of 1900 and #{Date.today.year}")) if !((1..31).include?(self.release_date.day) && (1..12).include?(self.release_date.month) && (1900..Date.today.year).include?(self.release_date.year))
    end 
  
end
