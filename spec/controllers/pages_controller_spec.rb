require 'spec_helper'

describe PagesController do

  describe "GET 'home'" do
    it "returns http success" do
      get 'home'
      response.should be_success
    end
  end

  describe "GET 'movies'" do
    it "returns http success" do
      get 'movies'
      response.should be_success
    end
  end

  describe "GET 'about'" do
    it "returns http success" do
      get 'about'
      response.should be_success
    end
  end

  describe "GET 'todo'" do
    it "returns http success" do
      get 'todo'
      response.should be_success
    end
  end

end
