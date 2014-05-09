require 'spec_helper'

describe TestinlectureController do

  describe "GET 'change_visibility'" do
    it "returns http success" do
      get 'change_visibility'
      response.should be_success
    end
  end

end
