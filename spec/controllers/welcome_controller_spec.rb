require 'spec_helper'

describe WelcomeController do
	before :each do
		@locale = I18n.default_locale
	end

	describe "GET #index" do
		it "renders the index template" do
			get :index, locale: @locale
			expect(response).to render_template 'index'
		end
	end

	describe "GET #lastest_users" do
		it "renders the users template" do
			get :users, locale: @locale
			expect(response).to render_template 'users'
		end
	end

	describe "GET #lastest_courses" do

		context "guest" do
			it "populates an array with all courses" do
				course1 = create(:course)
				course2 = create(:course)
				get :courses, locale: @locale
				expect(assigns(:courses)).to match_array([course1, course2])
			end
		end

		context "user logged" do
			it "populates an array of courses from which the user is not a member" do
				@user = create(:user)
    		set_user_session @user
				course1 = create(:course)
				course2 = create(:course)
				member = create(:member, user: @user, course: course1, type: :student)

				get :courses, locale: @locale
				expect(assigns(:courses)).to match_array([course2])
			end
		end
		it "renders the courses template" do
			get :courses, locale: @locale
			expect(response).to render_template 'courses'
		end
	end

end