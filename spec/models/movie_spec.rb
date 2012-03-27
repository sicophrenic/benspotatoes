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

require 'spec_helper'

describe Movie do
  
  before(:each) do
    @attr = { :title => "Example Movie", :director => "Example Director", :rating => "R",
              :location => "F", :quality => "720p", :release_date => Time.now }
  end
  
  it "should create a new instance given attributes" do
    Movie.create!(@attr)
  end
  
  it "should require a title" do
    Movie.new(@attr.merge(:title => "")).should_not be_valid
  end
  
  it "should reject duplicate titles" do
    Movie.create!(@attr)
    Movie.new(@attr).should_not be_valid
  end
  
  it "should reject duplicate titles by lettercase" do
    Movie.create!(@attr.merge(:title => @attr[:title].upcase))
    Movie.new(@attr.merge(:title => @attr[:title].upcase)).should_not be_valid
  end
  
  it "should require a rating" do
    Movie.new(@attr.merge(:rating => "")).should_not be_valid
  end
  
  it "should require a location" do
    Movie.new(@attr.merge(:location => "")).should_not be_valid
  end
  
  it "should require a quality" do
    Movie.new(@attr.merge(:quality => "")).should_not be_valid
  end
  
  it "should accept valid qualities" do
    qualities = %w[480p 720p 1080p]
    qualities.each do |quality|
      Movie.new(@attr.merge(:quality => quality)).should be_valid
    end
  end
  
  it "should reject invalid qualities" do
    qualities = %w[480i 720i 1080i 240p 540i 640i 640p]
    qualities.each do |quality|
      Movie.new(@attr.merge(:quality => quality)).should_not be_valid
    end
  end
end
