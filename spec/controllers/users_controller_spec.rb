require 'spec_helper'

describe UsersController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'queue'" do
    it "returns http success" do
      get 'queue'
      response.should be_success
    end
  end

end
