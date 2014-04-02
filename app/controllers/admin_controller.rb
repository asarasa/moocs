class AdminController < ApplicationController
	before_action :authorize_admin, only: [:users, :courses, :resources]

  def index
    
  end

  def users
  	@users = User.all.entries
  end

  def courses
  	@courses = Course.all.entries
  end

  def resources
  	@resources = Resource.all.entries
  end
end
