class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

private
	#[jimmys, foursquare]
	def template
		@template = "/assets/templates/dashboard"
	end
	helper_method :template

	def current_user
		@current_user ||= User.find(session[:user_id]) if session[:user_id]
	end
	helper_method :current_user

	def authorize
		redirect_to login_url, alert: "Not authorized" if current_user.nil?
	end

	def authorize_teacher
		redirect_to root_url, alert: "You are not the teacher" if !is_teacher?
	end

	def is_teacher?
		if !current_user.nil?
			@course.teachers.include?(current_user.id)
		end
	end
	helper_method :is_teacher?

	def is_member?
		if (!current_user.nil?)
			@course.users.include?(current_user)
		end
	end	
	helper_method :is_member?	
  
  	def is_myresource?
		if (!current_user.nil?)
    		current_user.resources.include?(@resource)
		end
	end	
	helper_method :is_myresource?	
  
  def have_forumpermission?
    if (!@course.nil?)
      @course.forumpermision == true
    end  
  end  
  helper_method :have_forumpermission?	
  
   def can_create_topic?
	    	is_teacher? or (is_member? and have_forumpermission?)
    end	
    helper_method :can_create_topic?	
  
    def can_edit_topic?(topic)
      utopic = User.find(topic.createBy)
      ucurrent = User.find(current_user)
      is_teacher? or (is_member? and have_forumpermission? and utopic == ucurrent)
    end	
    helper_method :can_edit_topic?	
  
    def can_create_message?
      utopic = User.find(@topic.createBy)
      ucurrent = User.find(current_user)
      is_teacher? or utopic == ucurrent or (is_member? and @topic == "Opened")
    end	
    helper_method :can_create_message?	
  
  def can_edit_message?(message)
      utopic = User.find(@topic.createBy)
      ucurrent = User.find(current_user)
      umessage = User.find(message.from)
      is_teacher? or utopic == ucurrent or (is_member? and @topic == "Opened" and umessage == ucurrent)
    end	
    helper_method :can_edit_message?	
end
