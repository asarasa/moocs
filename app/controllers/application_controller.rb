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
end
