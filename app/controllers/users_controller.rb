class UsersController < ApplicationController
	def new
		@user = User.new
	end

	def create
		@user = User.new user_params
		@user.register_date = DateTime.now
		if @user.save
			session[:user_id] = @user.id
	  		@user.update(:last_login => DateTime.now)
			redirect_to root_url, notice: "Thank you for signing up!"
		else
			render "new"
		end
	end

	def show
		@user = current_user
	end

	def edit
		@user = current_user
	end

	def update
	    @user = current_user
		
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
      params.require(:user).permit :username, :email, :password, :password_confirmation
    else  
      params.require(:user).permit :username, :email, :password, :password_confirmation		

    #elsif current_user.has_role :admin
    #  params.require(:user).permit! # Allow all user parameters
    #elsif current_user.has_role :user
    #  params.require(:user).permit :name, :email, :password, :password_confirmation
    end
  end	
end
