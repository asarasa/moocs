class AdminController < ApplicationController
	before_action :authorize_admin, only: [:users, :courses, :resources]

  def index
    
  end

  def users
  	@users = User.all.entries

    respond_to do |format|
      format.html { render @users }
      format.js {}
    end    
  end

  def courses
  	@courses = Course.all.entries

    respond_to do |format|
      format.html { render @resources }
      format.js {}
    end    
  end

  def resources
  	@resources = Resource.all.entries

    respond_to do |format|
      format.html { render @resources }
      format.js {}
    end    
  end

  def feedback
    @feedback = Feedback.all.entries

    respond_to do |format|
      format.html { render @feedback }
      format.js {}
    end    
  end  
end
