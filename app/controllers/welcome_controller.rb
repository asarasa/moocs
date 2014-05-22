class WelcomeController < ApplicationController

	def index
		@mainpage = true
		@courses = Course.desc(:start_date).where(active: true)
	end

	def courses
		@courses = Course.desc(:date_created).where(active: true)
    @categories = Course.categories.to_a
		# if current_user
		# 	@courses = all_courses - current_user.courses
		# else
		# 	@courses = all_courses
		# end
	end

	def category
		@category = params[:category];
		@courses = Course.where(category: @category).where(active: true)
		@category = I18n.t("course.categories.#{@category}")

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

  def feedback
    @feedback = Feedback.new(feedback_params)

    respond_to do |format|
      if @feedback.save
        @response = 'Your was successfully sended.'
        format.html { redirect_to root_url, notice: 'Your was successfully sended.' }
        format.js
      else
        @response = 'Your was not successfully sended.'
        format.html { redirect_to root_url, notice: 'Your was not successfully sended.' }
        format.js
      end
    end
  end

  private
    def feedback_params
      params.require(:feedback).permit(:email,:name, :content)
    end
end