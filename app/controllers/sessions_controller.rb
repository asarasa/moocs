class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.where(:email => params[:email]).first
  	if user && user.authenticate(params[:password])
  		session[:user_id] = user.id
  		user.update(:last_login => DateTime.now)
  		redirect_to root_url, notice: "Logged in!"
  	else
      redirect_to login_path, notice: "Email or password is invalid"
  	end
  end

  def destroy
  	session[:user_id] = nil
  	redirect_to root_url, notice: "Logged out!"
  end
end
