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
  validates :rating,  :presence => true,
                      :length   => { :maximum => 5 }
  validates :location,  :presence => true,
                        :length   => { :maximum => 1 }
  validates :quality, :presence => true

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
    Movie.find(:all, :order => :release_date).first.release_date
  end
end
