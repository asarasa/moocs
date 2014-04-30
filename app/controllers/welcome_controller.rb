class WelcomeController < ApplicationController

	def index
		@mainpage = true
		@courses = Course.desc(:start_date)
	end

	def users
		@users = User.desc(:register_date)
	end

	def courses
		all_courses = Course.desc(:date_created)
		if current_user
			@courses = all_courses - current_user.courses
		else
			@courses = all_courses
		end
	end

	def search
		@searchterm = params[:q]
    @courses = Course.any_of({ :name => /.*#{@searchterm}.*/ }, { :name => /.*#{@searchterm}.*/ })

		render 'search_results'
	end
end