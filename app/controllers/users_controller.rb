class UsersController < ApplicationController
	before_action :authorize, except: [:new, :create]
	before_action :unauthorize, only: [:new, :create]

	def index
		@users = User.all.entries
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new user_params
		@user.last_login = DateTime.now
		if @user.save
			session[:user_id] = @user.id
			redirect_to root_url, notice: "Thank you for signing up!"
		else
			render "new"
		end
	end

	def show
    if current_user.admin & !params[:id].nil?
      @user = User.find(params[:id])
    else
		  @user = current_user
    end
	end

	def edit
		if !params[:id].nil? && current_user.admin
			@user = User.find(params[:id])
		else
			@user = current_user
		end
	end

	def update
		if !params[:id].nil? && current_user.admin
			@user = User.find(params[:id])
		else
	  	@user = current_user
	  end
		
		respond_to do |format|
		if @user.update(user_params)
			format.html { redirect_to(root_url, :notice => 'User was successfully updated.') }
			format.xml  { head :ok }
		else
			format.html { render :action => "edit" }
			format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
		end
    end
  end

private
  def user_params
    # params.require(:user) throws an error if params[:user] is nil

    if current_user.nil? # Guest
      # Remove all keys from params[:user] except :email, :password, and :password_confirmation
      params.require(:user).permit :name, :lastname, :email, :photo, :password, :password_confirmation
    else  
      params.require(:user).permit :name, :lastname, :email, :photo, :password, :password_confirmation		

    #elsif current_user.has_role :admin
    #  params.require(:user).permit! # Allow all user parameters
    #elsif current_user.has_role :user
    #  params.require(:user).permit :name, :email, :password, :password_confirmation
    end
  end	
end
