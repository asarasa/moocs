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

	def category
		@category = params[:category];
		@courses = Course.where(category: @category)
		@category = I18n.t("course.categories.#{@category}")
		logger.debug @courses.length
	    respond_to do |format|
	      if !@courses.nil? && @courses.length > 0
	        format.html { render @courses }
	        format.js {}
	        format.json { render json: @courses, status: :courses, location: @courses }
	      else
	        format.html { render @courses }
	        format.js { render 'welcome/no_courses' }
	        format.json { render json: "Error" }
	      end
	    end
	end

	def search
		@searchterm = params[:q]
    @courses = Course.any_of({ :name => /.*#{@searchterm}.*/ }, { :name => /.*#{@searchterm}.*/ })

		render 'search_results'
	end
end