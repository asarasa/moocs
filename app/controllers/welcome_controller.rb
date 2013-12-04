class WelcomeController < ApplicationController

	def index
		@mainpage = true
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
		#logger.debug "all_courses - current_user.courses : #{@courses}"
	end

	def user_courses
		@courses = current_user.courses
	end

end