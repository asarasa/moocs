class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale

private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options={})
    { :locale => I18n.locale }
  end  

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

  def authorize_member
    if !current_user.nil?
      if !@course.is_member?(current_user)
        redirect_to course_path(@course), alert: "You are not member of this course."
      end
    end
  end   

  def authorize_admin
    if current_user.nil?
      redirect_to login_url, alert: "Not authorized"
    else
      redirect_to root_url, alert: "Not authorized" if !current_user.admin
    end
  end

  def authorize_teacher
    if current_user.nil?
      redirect_to login_url, alert: "Not authorized"
    else    
      redirect_to root_url, alert: "You are not the teacher" if !@course.is?(current_user, 'teacher')
    end
  end  

  def unauthorize
    redirect_to login_url, alert: "You can't sign up if already has logged" if current_user
  end

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
      is_teacher? or (is_member? and have_forumpermission? and topic.createBy == current_user.username)
    end	
    helper_method :can_edit_topic?	
  
    def can_create_message?
      is_teacher? or topic.createBy == current_user.username or (is_member? and @topic == "Opened")
    end	
    helper_method :can_create_message?	
  
  def can_edit_message?(message)
    is_teacher? or  @topic.createBy == current_user.username or (is_member? and @topic == "Opened" and message.from == ucurrent)
    end	
    helper_method :can_edit_message?	
end
